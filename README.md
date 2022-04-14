# Cloudflare_DDNS
## A simple Cloudflare DDNS script.
### Before use
You should install curl and jq first.
```
sudo apt install curl jq
```
Then you need to edit `Cloudflare_DDNS.sh`
```
CF_Zone_ID="YOUR_ZONE_ID"
CF_Token="YOUR_API_TOKEN"
CF_Domain="YOUR_DOMAIN"
```
********
It's only support IPv4 now.
