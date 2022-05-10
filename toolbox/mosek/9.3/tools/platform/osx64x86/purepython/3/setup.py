from distutils.core import setup
import distutils.command.install
import platform,sys
import os,os.path
import subprocess
import ctypes

class InstallationError(Exception): pass

major,minor,_,_,_ = sys.version_info
if major != 3:
    print ("Python 3.0+ required, got %d.%d" % (major,minor))

instdir = os.path.abspath(os.path.join(__file__,'..'))
mosekinstdir = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)),'..','..','bin'))

ver = ('|MSKMAJORVER|','|MSKMINORVER|')

libd = {
    'osx64x86'     : [ 'libmosek64.%s.%s.dylib'%ver, 'libmosekxx%s_%s.dylib'%ver,'libcilkrts.5.dylib', ],
    'linux64x86'   : [ 'libmosek64.so.%s.%s'   %ver, 'libmosekxx%s_%s.so'%ver,   'libcilkrts.so.5',    ],
    'linuxaarch64' : [ 'libmosek64.so.%s.%s'   %ver, 'libmosekxx%s_%s.so'%ver,                         ],
    'win64x86'     : [ 'mosek64_%s_%s.dll'     %ver, 'mosekxx%s_%s.dll'%ver,     'cilkrts20.so',       ],
    'win32x86'     : [ 'mosek%s_%s.dll'        %ver, 'mosekxx%s_%s.dll'%ver,     'cilkrts20.so',       ]
}

def getsysid():
    sysid = None
    sysname = platform.system()
    hwarch  = platform.machine()
    is_64bit = sys.maxsize > (1<<32)
    exearch = '64bit' if is_64bit else '32bit'

    if sysname == 'Darwin':
        if hwarch == 'x86_64' and exearch == '64bit':
            sysid = 'osx64x86'
    elif sysname == 'Linux':
        if   hwarch == 'aarch64' and exearch == '64bit':
            sysid = 'linuxaarch64'
        elif hwarch in [ 'x86_64', 'AMD64' ] and exearch == '64bit':
            sysid = 'linux64x86'
    elif sysname == 'Windows':
        if   hwarch in [ 'x86_64', 'AMD64' ] and exearch == '64bit':
            sysid = 'win64x86'
        elif hwarch in [ 'x86_64', 'x86', 'AMD64' ] and exearch == '32bit':
            sysid = 'win32x86'
    else:
        raise InstallationError("Unsupported system: %s %s on %s" % (sysname,exearch,hwarch))

    if sysid is None:
        raise InstallationError("Unsupported system: %s %s on %s" % (sysname,exearch,hwarch))
    
    return sysid

sysid = getsysid()

os.chdir(os.path.abspath(os.path.dirname(__file__)))

def _post_install(sitedir):
    mskdir = os.path.join(sitedir,'mosek')
    with open(os.path.join(mskdir,'mosekorigin.py'),'wt',encoding='ascii') as f:
        f.write('__mosekinstpath__ = {0}\n'.format(repr(mosekinstdir)))

class install(distutils.command.install.install):
    def run(self):
        distutils.command.install.install.run(self)
        self.execute(_post_install,
                     (self.install_lib,),
                     msg="Fixing library paths")

setup( name             = 'Mosek',
       cmdclass         = { 'install' : install },
       version          = '9.3.18',
       description      = 'Mosek/Python APIs',
       long_description = 'Interface for MOSEK',
       author           = 'Mosek ApS',
       author_email     = "support@mosek.com",
       license          = "See license.pdf in the MOSEK distribution",
       url              = 'http://www.mosek.com',
       packages         = [ 'mosek', 'mosek.fusion','mosek.fusion.impl' ],
       )



