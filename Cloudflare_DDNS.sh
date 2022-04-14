CF_Zone_ID="YOUR_ZONE_ID"
CF_Token="YOUR_API_TOKEN"
CF_Domain="YOUR_DOMAIN"

##Get My IPv4 Address
current_ip=`curl -4sX GET "https://api.myip.com" | jq ".ip" `

##Get Cloudflare DNS Record ID
dns_record_id=`curl -sX GET "https://api.cloudflare.com/client/v4/zones/$CF_Zone_ID/dns_records?type=A&name=$CF_Domain" -H "Authorization: Bearer $CF_Token" -H "Content-Type: application/json" | jq -c ".result[].id" | sed 's/\"//g' `

if [ -z "$dns_record_id" ] ; then
    ##Create Cloudflare DNS Record
    curl -sX POST "https://api.cloudflare.com/client/v4/zones/$CF_Zone_ID/dns_records" -H "Authorization: Bearer $CF_Token" -H "Content-Type: application/json" --data '{"type":"A","name":"'$CF_Domain'","content":'$current_ip',"ttl":120,"priority":10,"proxied":false}' | jq .
else
    ##Update Cloudflare DNS Record
    curl -sX PUT "https://api.cloudflare.com/client/v4/zones/$CF_Zone_ID/dns_records/$dns_record_id" -H "Authorization: Bearer $CF_Token" -H "Content-Type: application/json" --data '{"type":"A","name":"'$CF_Domain'","content":'$current_ip',"ttl":120,"proxied":false}' | jq .
fi
