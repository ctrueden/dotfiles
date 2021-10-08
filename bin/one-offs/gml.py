#!/usr/bin/env python
#
# Copyright (C) 2004 Mark H. Lyon <mark@marklyon.org>
#
# This file is the Mbox & Maildir to Gmail Loader (GML).
#
# Mbox & Maildir to Gmail Loader (GML) is free software; you can redistribute  
# it and/or modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation; either version 2 of 
# the License, or (at your option) any later version.  
#
# GML is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with GML; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

# Origional development thread at Ars Technica:
# http://episteme.arstechnica.com/eve/ubb.x?a=tpc&s=50009562&f=6330927813&m=108000474631
#
# Version 0.1 - 15 Jun 04 16:28 Supports Mbox
# Version 0.2 - 15 Jun 04 18:48 Implementing Magus` suggestion for Maildir
# Version 0.3 - 16 Jun 04 16:17 Implement Rold Gold suggestion for counters
# Version 0.4 - 17 Jun 04 13:15 Add support for changing SMTP server at command line


import mailbox, smtplib, sys, time, string

def main ():
 print "\nMbox & Maildir to Gmail Loader (GML) by Mark Lyon <mark@marklyon.org>\n"  
 if len(sys.argv)  in (4, 5) :
  boxtype_in     = sys.argv[1]
  mailboxname_in = sys.argv[2]
  emailname_in   = sys.argv[3]
  try: 
   smtpserver_in = sys.argv[4]
  except:
   smtpserver_in = 'localhost'
   #smtpserver_in = 'gsmtp57.google.com'  
  count = [0,0,0]
  try:
   if boxtype_in == "maildir":
    mb = mailbox.Maildir(mailboxname_in)
   else:  
    mb = mailbox.UnixMailbox (file(mailboxname_in,'r'))        
   msg = mb.next()    
   while msg is not None:
    try:
     document = msg.fp.read()
     if document is not None:
      time.sleep(2)
      try:
       fullmsg = msg.__str__( ) + '\x0a' + document
       server = smtplib.SMTP(smtpserver_in)
       server.sendmail(msg.getaddr('From')[1], emailname_in, fullmsg)
       server.quit()
       count[0] = count[0] + 1
       print "    %d Forwarded a message from  : %s"  % (count[0], msg.getaddr('From')[1])
      except:
       count[1] = count[1] + 1
       print "*** %d ERROR SENDING MESSAGE FROM: %s"  % (count[1], msg.getaddr('From')[1])         
      msg = mb.next()
    except:
     count[2] = count[2] + 1
     print "*** %d MESSAGE READ FAILED, SKIPPED" % (count[2])
     msg = mb.next()  
   print "\nDone. Stats: %d success %d error %d skipped." % (count[0], count[1], count[2])
  except:
   print "*** Can't open file or directory.  Is the path correct? ***\n"
   print 'Usage: gml.exe [mbox or maildir] [mbox file or maildir path] [gmail address] [Optional SMTP Server]'
   print 'Exmpl: gml.exe mbox "c:\mail\Inbox" marklyon@gmail.com'
   print 'Exmpl: gml.exe maildir "c:\mail\Inbox\" marklyon@gmail.com gsmtp171.google.com\n'
 else:
  print 'Usage: gml.exe [mbox or maildir] [mbox file or maildir path] [gmail address] [Optional SMTP Server]'
  print 'Exmpl: gml.exe mbox "c:\mail\Inbox" marklyon@gmail.com'
  print 'Exmpl: gml.exe maildir "c:\mail\Inbox\" marklyon@gmail.com gsmtp171.google.com\n'   

if __name__ == '__main__':
 main ()
