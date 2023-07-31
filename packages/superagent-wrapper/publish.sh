version=$1
http_version=$2
rhino_dir="${3:-/home/adrian/code/rhinofi/rhino-core}"

sed -i 's|@api-ts/superagent-wrapper|@rhino.fi/api-ts-superagent-wrapper|' package.json
sed -i "s|\"version\": \"0.0.0-semantically-released|\"version\": \"$version|" package.json
sed -i "s|\"@api-ts/io-ts-http\": \"0.0.0-semantically-released|\"@api-ts/io-ts-http\": \"$http_version|" package.json

NPM_ACCESS_TOKEN=$(nix run -f "$rhino_dir/nix/pkgs.nix" dvf.configPerEnv.prd.secrets.NPM_ACCESS_TOKEN_WRITE.decrypt) npm publish --workspace . "$@"