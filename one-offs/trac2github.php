<?php

// Adapted from:
// https://github.com/trustmaster/trac2github

// CONFIGURATION

$username   = 'username';
$password   = 'password';

$trac_author = 'curtis';

// Set this to true if you want to see the JSON output sent to GitHub
$verbose = false;

// Path to SQLite database file
$sqlite_trac_path = '/data/devel/trac/imagej/db/trac.db';

// URL of Trac instance
$trac_url = 'http://trac.imagej.net';

// DO NOT EDIT BELOW

if ($argc < 3) {
	echo "Usage: trac2github.php project repo ticket_id [two_factor_code]\n";
	exit(1);
}

$project    = $argv[1];
$repo       = $argv[2];
$ticket_id  = $argv[3];
if ($argc >= 5) { $two_factor = $argv[4]; }

error_reporting(E_ALL ^ E_NOTICE);
ini_set('display_errors', 1);
set_time_limit(0);

// Connect to Trac database using PDO
if (!file_exists($sqlite_trac_path)) {
	echo "SQLITE file does not exist.\n";
	exit;
}
$trac_db = new PDO('sqlite:'.$sqlite_trac_path);

// Set PDO to throw exceptions on error.
$trac_db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

echo "Connected to Trac\n";

// Export tickets
$res = $trac_db->query("SELECT * FROM ticket WHERE id = $ticket_id");
foreach ($res->fetchAll() as $row) {
	$body = body_with_suffix(make_body($row['description']), $ticket_id);

	// There is a strange issue with summaries containing percent signs...
	$resp = github_add_issue(array(
		'title' => preg_replace("/%/", '[pct]', $row['summary']),
		'body' => $body
	));
	if (isset($resp['number'])) {
		// OK
		$issue_id = $resp['number'];
		echo "Ticket #$ticket_id converted to issue #$issue_id\n";
		trac_close($ticket_id, $issue_id);
	} else {
		// Error
		$error = print_r($resp, 1);
		echo "Failed to convert a ticket #{$row['id']}: $error\n";
	}
}

//-------------------

function trac_close($ticket_id, $issue_id) {
	global $trac_db, $trac_author, $project, $repo;

	echo "ticket_id = $ticket_id\n";
	echo "issue_id = $issue_id\n";

	$res = $trac_db->query(
		"SELECT status FROM ticket WHERE id = $ticket_id")->fetchAll();
	$old_status = $res[0][0];

	$res = $trac_db->query(
		"SELECT resolution FROM ticket WHERE id = $ticket_id")->fetchAll();
	$old_resolution = $res[0][0];

	$res = $trac_db->query("SELECT MAX(oldvalue) FROM ticket_change " .
		"WHERE field = 'comment' AND ticket = $ticket_id")->fetchAll();
	$comment_no = intval($res[0][0]) + 1;

	$tm = intval(1000000 * microtime(true));

	echo "old_status = $old_status\n";
	echo "old_resolution = $old_resolution\n";
	echo "comment_no = $comment_no\n";
	echo "time = $tm\n";

	// mark ticket as closed, moved
	$trac_db->query("UPDATE ticket " .
		"SET status = 'closed', resolution = 'moved' WHERE id = $ticket_id");

	// set status to closed
	$trac_db->query("INSERT INTO ticket_change " .
		"(ticket, time, author, field, oldvalue, newvalue) " .
		"VALUES ($ticket_id, $tm, '$trac_author', " .
		"'status', '$old_status', 'closed')");

	// set resolution to fixed
	$trac_db->query("INSERT INTO ticket_change " .
		"(ticket, time, author, field, oldvalue, newvalue) " .
		"VALUES ($ticket_id, $tm, '$trac_author', " .
		"'resolution', '$old_resolution', 'moved')");

	// add comment stating where the ticket has migrated
	$trac_db->query("INSERT INTO ticket_change " .
		"(ticket, time, author, field, oldvalue, newvalue) " .
		"VALUES ($ticket_id, $tm, '$trac_author', 'comment', '$comment_no', " .
		"'Migrated to https://github.com/$project/$repo/issues/$issue_id')");
}

function github_post($url, $json, $patch = false) {
	global $username, $password, $two_factor;
	$ch = curl_init();
	curl_setopt($ch, CURLOPT_USERPWD, "$username:$password");
	curl_setopt($ch, CURLOPT_URL, "https://api.github.com$url");
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
	if ($two_factor) {
		curl_setopt($ch, CURLOPT_HTTPHEADER, array("X-GitHub-OTP: $two_factor"));
	}
	curl_setopt($ch, CURLOPT_HEADER, false);
	curl_setopt($ch, CURLOPT_POST, true);
	curl_setopt($ch, CURLOPT_POSTFIELDS, $json);
	curl_setopt($ch, CURLOPT_USERAGENT, "trac2github for $project, ctrueden@wisc.edu");
	if ($patch) {
		curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'PATCH');
	}
	$ret = curl_exec($ch);
	if (!$ret) {
		trigger_error(curl_error($ch));
	}
	curl_close($ch);
	return $ret;
}

function github_add_milestone($data) {
	global $project, $repo, $verbose;
	if ($verbose) print_r($data);
	return json_decode(github_post("/repos/$project/$repo/milestones", json_encode($data)), true);
}

function github_add_label($data) {
	global $project, $repo, $verbose;
	if ($verbose) print_r($data);
	return json_decode(github_post("/repos/$project/$repo/labels", json_encode($data)), true);
}

function github_add_issue($data) {
	global $project, $repo, $verbose;
	if ($verbose) print_r($data);
	return json_decode(github_post("/repos/$project/$repo/issues", json_encode($data)), true);
}

function github_add_comment($issue, $body) {
	global $project, $repo, $verbose;
	if ($verbose) print_r($body);
	return json_decode(github_post("/repos/$project/$repo/issues/$issue/comments", json_encode(array('body' => $body))), true);
}

function github_update_issue($issue, $data) {
	global $project, $repo, $verbose;
	if ($verbose) print_r($body);
	return json_decode(github_post("/repos/$project/$repo/issues/$issue", json_encode($data), true), true);
}

function make_body($description) {
	return empty($description) ? 'None' : translate_markup($description);
}

function translate_markup($data) {
	// Replace code blocks with an associated language
	$data = preg_replace('/\{\{\{(\s*#!(\w+))?/m', '```$2', $data);
	$data = preg_replace('/\}\}\}/', '```', $data);

	// Avoid non-ASCII characters, as that will cause trouble with json_encode()
	$data = preg_replace('/[^(\x00-\x7F)]*/','', $data);

	// Translate Trac-style links to Markdown
	$data = preg_replace('/\[([^ ]+) ([^\]]+)\]/', '[$2]($1)', $data);

	// Possibly translate other markup as well?
	return $data;
}

function body_with_suffix($body, $id) {
	global $trac_url;
	return "$body\n\nMigrated-From: $trac_url/ticket/$id";
}

?>
