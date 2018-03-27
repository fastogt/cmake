#!/usr/bin/env python3

'''
Code-signs all nested binaries inside an app bundle (excluding the app itself).
'''

import os, sys, re, platform, subprocess

SIGN_EXTENSIONS = ['.so', '.dylib']  # extension-less binaries are auto-included
CODE_SIGN_OPTS = ['--verbose', '--force', '--sign']


def run_command(cmd: list):
    try:
        process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
        for output in process.stdout:
            line = output.strip()
            print(line.decode("utf-8"))
            sys.stdout.flush()
        rc = process.poll()
    except subprocess.CalledProcessError as ex:
        raise ex

    return rc


def get_os() -> str:
    uname_str = platform.system()
    if 'MINGW' in uname_str:
        return 'windows'
    elif 'MSYS' in uname_str:
        return 'windows'
    elif uname_str == 'Windows':
        return 'windows'
    elif uname_str == 'Linux':
        return 'linux'
    elif uname_str == 'Darwin':
        return 'macosx'
    elif uname_str == 'FreeBSD':
        return 'freebsd'
    elif uname_str == 'Android':
        return 'android'
    else:
        return 'unknown'


def is_translations(path):
    ext = os.path.splitext(path)[1]
    return ext == '.qm'


def is_probably_binary(path):
    ext = os.path.splitext(path)[1]
    if ext in SIGN_EXTENSIONS:
        return True
    return (len(ext) == 0) and os.access(path, os.X_OK) and not os.path.islink(path)


def is_definitely_binary(path):
    return b'Mach-O' in subprocess.check_output(['file', '--brief', path])


def get_signing_path(path):
    path_str = str(path)
    m = re.match('(.*/(.*)\.framework)/Versions/./(.*)', path_str)
    if m and (m.lastindex == 3) and m.group(2) == m.group(3):
        # This is the main binary of a framework. Sign the framework version instead.
        path = m.group(1)
    m = re.match('.*/(.*)\.app/Contents/MacOS/(.*)', path_str)
    if m and (m.lastindex == 2) and m.group(1) == m.group(2):
        # This is the main binary of the app bundle. Exclude it.
        path = None
    return path


def get_signable_files(path):
    all_files = [os.path.join(root, fn) for root, dirs, names in os.walk(path) for fn in names]
    trans = filter(is_translations, all_files)
    bins = filter(is_probably_binary, all_files)
    bins = filter(is_definitely_binary, bins)
    files = list(bins) + list(trans)
    mapped_sign = filter(None, map(get_signing_path, files))
    return sorted(mapped_sign, reverse=True)


def code_sign_nested_macosx(identity, path):
    signables = get_signable_files(path)
    if len(signables) == 0:
        print("No signable binaries found.")
        return False
    try:
        for sign in signables:
            run_command(['codesign'] + CODE_SIGN_OPTS + [identity, sign])
        run_command(['codesign'] + CODE_SIGN_OPTS + [identity, path])
    except subprocess.CalledProcessError:
        print('Code signing failed.')
        exit(1)
    print('Code signing successfully complete.')


def main():
    if len(sys.argv) != 3:
        print('Usage: %s signing_identity app_path' % os.path.basename(__file__))
        exit(1)
    cs_identity, app_path = sys.argv[1:]
    os_name = get_os()
    print('Start signing path: {0}'.format(app_path))
    if os_name == 'macosx':
        code_sign_nested_macosx(cs_identity, app_path)
    else:
        print('Please implement code sign for: {0}, application path: {1}'.format(os_name, app_path))


if __name__ == '__main__':
    main()
