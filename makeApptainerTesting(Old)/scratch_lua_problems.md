SOME USEFUL COMMANDS
For solving the problem with lua:
- see https://github.com/AIandGlobalDevelopmentLab/DHS-Data/issues/1

apptainer shell --fakeroot --writable-tmpfs <<path to apptainer image>>.sif
apptainer shell --fakeroot --writable-tmpfs /mimer/NOBACKUP/groups/globalpoverty1/hans/images/hans_misc.sif 

I think it needs to be in noble - No this didn't help

apt-get install -y lua5.3 lua-bit32:amd64 lua-posix:amd64 lua-posix-dev liblua5.3-0:amd64 liblua5.3-dev:amd64 tcl tcl-dev tcl8.6 tcl8.6-dev:amd64 libtcl8.6:amd64

apt-get install -y luarocks

## apt-get install -y liblua5.3-dev #not needed

luarocks install luaposix

LUAROCKS_PREFIX=/usr/local
export LUA_PATH="$LUAROCKS_PREFIX/share/lua/5.1/?.lua;$LUAROCKS_PREFIX/share/lua/5.1/?/init.lua;;"
export LUA_CPATH="$LUAROCKS_PREFIX/lib/lua/5.1/?.so;;"

LUAROCKS_PREFIX=/usr/local
export LUA_PATH="$LUAROCKS_PREFIX/share/lua/5.3/?.lua;$LUAROCKS_PREFIX/share/lua/5.3/?/init.lua;;"
export LUA_CPATH="$LUAROCKS_PREFIX/lib/lua/5.3/?.so;;"

rm /usr/bin/lua

rm -r /usr/share/lmod/


LUAROCKS_PREFIX=/usr
export LUA_PATH="$LUAROCKS_PREFIX/share/lua/5.1/?.lua;$LUAROCKS_PREFIX/share/lua/5.1/?/init.lua;;"
export LUA_CPATH="$LUAROCKS_PREFIX/lib/lua/5.1/?.so;;"

LUAROCKS_PREFIX=/usr
export LUA_PATH="$LUAROCKS_PREFIX/share/lua/5.1/?.lua;$LUAROCKS_PREFIX/share/lua/5.1/?/init.lua;;"
export LUA_CPATH="/usr/lib/lua/5.3/?.so;;"

cp -r /usr/lib/x86_64-linux-gnu/lua/5.3/ /usr/lib64/lua/


update-alternatives --install /usr/bin/lua \
    lua-interpreter /usr/bin/lua5.3 130 \
    --slave /usr/share/man/man1/lua.1.gz lua-manual \
    /usr/share/man/man1/lua5.3.1.gz
update-alternatives --install /usr/bin/luac \
    lua-compiler /usr/bin/luac5.3 130 \
    --slave /usr/share/man/man1/luac.1.gz lua-compiler-manual \
    /usr/share/man/man1/luac5.3.1.gz
ln -s /usr/lib/x86_64-linux-gnu/liblua5.3-posix.so \
    /usr/lib/x86_64-linux-gnu/lua/5.3/posix.so



lua -e 'print(package.path)'
	/usr/local/share/lua/5.3/?.lua;
	/usr/local/share/lua/5.3/?/init.lua;
	/usr/local/share/lua/5.3/?.lua;
	/usr/local/share/lua/5.3/?/init.lua;
	/usr/local/lib/lua/5.3/?.lua;
	/usr/local/lib/lua/5.3/?/init.lua;
	/usr/share/lua/5.3/?.lua;
	/usr/share/lua/5.3/?/init.lua;
	./?.lua;./?/init.lua;

lua -e 'print(package.cpath)'
	/usr/local/lib/lua/5.3/?.so;
	/usr/local/lib/lua/5.3/?.so;
	/usr/lib/x86_64-linux-gnu/lua/5.3/?.so;
	/usr/lib/lua/5.3/?.so;
	/usr/local/lib/lua/5.3/loadall.so;./?.so;


LUAROCKS_PREFIX=/usr
export LUA_PATH="$LUAROCKS_PREFIX/share/lua/5.1/?.lua;$LUAROCKS_PREFIX/share/lua/5.1/?/init.lua;;"
export LUA_CPATH="/usr/local/lib/lua/5.3/?.so;;"



prepend_path("LUA_PATH", "/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua")
prepend_path("LUA_CPATH", "/usr/local/lib/lua/5.3/?.so")

#FIND:
find /usr/ -type d -name "lmod"

find /usr/ -wholename "*5.3/posix/glob/init.lua"


        no file '/usr/share/lua/5.3/posix/glob.lua'
        no file '/usr/share/lua/5.3/posix/glob/init.lua'
        no file '/usr/lib64/lua/5.3/posix/glob.lua'
        no file '/usr/lib64/lua/5.3/posix/glob/init.lua'
        no file '/usr/lib64/lua/5.3/posix/glob.so'
        no file '/usr/lib64/lua/5.3/loadall.so'
        no file '/usr/lib64/lua/5.3/posix.so'
        no file '/usr/lib64/lua/5.3/loadall.so'

cp -r /usr/lib/lua/5.3 /usr/lib64/lua/5.3

THIS DID SOMETHING:
cp -r /usr/lib/lua/5.3 /usr/lib64/lua/

This requires 
luarocks install luafilesystem --tree=/usr 

Or without --tree maybe
cp -r /usr/local/lib/lua/5.3 /usr/lib64/lua/5.3












___________________________



apt-get update
apt-get install -y lua5.3 lua-bit32:amd64 lua-posix:amd64 lua-posix-dev liblua5.3-0:amd64 liblua5.3-dev:amd64 tcl tcl-dev tcl8.6 tcl8.6-dev:amd64 libtcl8.6:amd64

update-alternatives --install /usr/bin/lua \
    lua-interpreter /usr/bin/lua5.3 130 \
    --slave /usr/share/man/man1/lua.1.gz lua-manual \
    /usr/share/man/man1/lua5.3.1.gz
update-alternatives --install /usr/bin/luac \
    lua-compiler /usr/bin/luac5.3 130 \
    --slave /usr/share/man/man1/luac.1.gz lua-compiler-manual \
    /usr/share/man/man1/luac5.3.1.gz
ln -s /usr/lib/x86_64-linux-gnu/liblua5.3-posix.so \
    /usr/lib/x86_64-linux-gnu/lua/5.3/posix.so

apt-get install -y luarocks


LUAROCKS_PREFIX=/usr/local
export LUA_PATH="$LUAROCKS_PREFIX/lib/lua/5.3/?.lua;$LUAROCKS_PREFIX/lib/lua/5.3/?/init.lua;;"
export LUA_CPATH="$LUAROCKS_PREFIX/lib/lua/5.3/?.so;;"

luarocks install luaposix

apt-get install -y lmod


/usr/local/lib/lua/5.3/posix/ctype.so

export LUA_CPATH="/usr/local/lib/lua/5.3/?.so;$LUA_CPATH"
export LUA_PATH="/usr/local/lib/lua/5.3/?.lua;/usr/local/lib/lua/5.3/?/init.lua;$LUA_PATH"

/usr/bin/lua -e "require('posix.ctype'); print('posix module loaded successfully')"
luarocks install luaposix --tree=/usr
