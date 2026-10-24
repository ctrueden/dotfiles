# Migration script for migrating old-style bytedeco javacpp projects to new-style.
#
# This script was written by Claude Opus 5.5 in Oct 2026, and used to migrate the
# IJ-OpenCV project, last updated in March 2021, to then-current SciJava practices.
#
# Files using one opencv_core import for both classes and functions (opencv_core.Point,
# opencv_core.normalize), no longer work now that they live in different places. Calls
# to functions and constants keep their opencv_xxx.foo(...) form, now imported from
# org.bytedeco.opencv.global.*. Class references now use explicit imports and plain
# names (Mat, Point2f, RotatedRect, …). Added imports go after the existing import block
# rather than in sorted order.

import re, sys, zipfile, pathlib
jar, root = sys.argv[1], sys.argv[2]
# class simple name -> module (prefer non-cuda)
classes = {}
for n in zipfile.ZipFile(jar).namelist():
    m = re.fullmatch(r'org/bytedeco/opencv/(opencv_[a-z0-9]+)/([A-Za-z0-9_]+)\.class', n)
    if m:
        mod, cls = m.groups()
        if cls not in classes or 'cuda' in classes[cls][0]:
            classes.setdefault(cls, [])
            classes[cls] = [mod]
cls_mod = {k: v[0] for k, v in classes.items()}
for f in pathlib.Path(root).rglob('*.java'):
    src = f.read_text()
    orig = src
    # static imports
    src = re.sub(r'import static org\.bytedeco\.javacpp\.(opencv_[a-z0-9]+)\.', r'import static org.bytedeco.opencv.global.\1.', src)
    # explicit class imports / wildcard
    def fix_imp(m):
        mod, name = m.group(1), m.group(2)
        if name == '*': return f'import org.bytedeco.opencv.{mod}.*;'
        return f'import org.bytedeco.opencv.{cls_mod.get(name, mod)}.{name};'
    src = re.sub(r'import org\.bytedeco\.javacpp\.(opencv_[a-z0-9]+)\.([A-Za-z0-9_*]+);', fix_imp, src)
    # module imports
    src = re.sub(r'import org\.bytedeco\.javacpp\.(opencv_[a-z0-9]+);', r'import org.bytedeco.opencv.global.\1;', src)
    # qualified class refs in body
    imports = set(re.findall(r'^import\s+(?:static\s+)?[\w.]+\.(\w+);', src, re.M))
    needed = {}
    def fix_ref(m):
        mod, name = m.group(1), m.group(2)
        if name not in cls_mod: return m.group(0)
        newmod = cls_mod[name]
        # bare usage elsewhere (not preceded by '.') or conflicting import?
        bare = re.search(r'(?<![.\w])' + name + r'\b', re.sub(r'^import.*$', '', src, flags=re.M))
        conflict = any(re.search(rf'^import\s+[\w.]+\.{name};', src, re.M) and not re.search(rf'^import\s+org\.bytedeco\.opencv\.{newmod}\.{name};', src, re.M) for _ in [0])
        already = re.search(rf'^import\s+org\.bytedeco\.opencv\.{newmod}\.({name}|\*);', src, re.M)
        if (bare or conflict) and not already:
            return f'org.bytedeco.opencv.{newmod}.{name}'
        needed[name] = newmod
        return name
    body_start = 0
    lines = src.split('\n')
    out = []
    for line in lines:
        if line.startswith('import ') or line.startswith('package '):
            out.append(line)
        else:
            out.append(re.sub(r'(?<![.\w])(opencv_[a-z0-9]+)\.([A-Z]\w*)\b', fix_ref, line))
    src = '\n'.join(out)
    # add needed imports
    add = [f'import org.bytedeco.opencv.{m}.{n};' for n, m in sorted(needed.items())
           if not re.search(rf'^import org\.bytedeco\.opencv\.{m}\.{n};', src, re.M)]
    if add:
        # insert after last import
        idx = [m.end() for m in re.finditer(r'^import .*;$', src, re.M)][-1]
        src = src[:idx] + '\n' + '\n'.join(add) + src[idx:]
    # drop module imports no longer referenced
    for mod in set(re.findall(r'^import org\.bytedeco\.opencv\.global\.(opencv_\w+);$', src, re.M)):
        body = re.sub(r'^import.*$', '', src, flags=re.M)
        if not re.search(rf'(?<![.\w]){mod}\.', body):
            src = re.sub(rf'^import org\.bytedeco\.opencv\.global\.{mod};\n', '', src, flags=re.M)
    if src != orig:
        f.write_text(src)
        print('updated', f)
