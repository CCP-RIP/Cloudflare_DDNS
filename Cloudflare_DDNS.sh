CF_Zone_ID="YOUR_ZONE_ID"
CF_Token="YOUR_API_TOKEN"
CF_Domain="YOUR_DOMAIN"

##Get My IPv4 Address
current_ip="$(curl -4sX GET "https://api.myip.com" | jq -c ".ip" )"

##Print Current IPv4 Address
echo Your current IP address is "$current_ip".

##Get Cloudflare DNS Record ID and Latest Updated IP
dns_record_response="$(curl -sX GET "https://api.cloudflare.com/client/v4/zones/$CF_Zone_ID/dns_records?type=A&name=$CF_Domain" -H "Authorization: Bearer $CF_Token" -H "Content-Type: application/json" | jq -c "." )"
dns_record_id="$(echo $dns_record_response | jq -c ".result[].id" | sed 's/\"//g' )"
latest_updated_ip="$(echo $dns_record_response | jq -c ".result[].content" )"
latest_updated_time="$(echo $dns_record_response | jq -c ".result[].modified_on" )"

##Check The Latest Updated IP
if  [ "$latest_updated_ip" = "$current_ip" ]; then
    echo "Your IP address $latest_updated_ip is already up to date at $latest_updated_time."
else
##Create or Update DNS Record
    [ -z "$dns_record_id" ] && curl -sX POST "https://api.cloudflare.com/client/v4/zones/$CF_Zone_ID/dns_records" -H "Authorization: Bearer $CF_Token" -H "Content-Type: application/json" --data '{"type":"A","name":"'$CF_Domain'","content":'$current_ip',"ttl":120,"priority":10,"proxied":false}' | jq . || curl -sX PUT "https://api.cloudflare.com/client/v4/zones/$CF_Zone_ID/dns_records/$dns_record_id" -H "Authorization: Bearer $CF_Token" -H "Content-Type: application/json" --data '{"type":"A","name":"'$CF_Domain'","content":'$current_ip',"ttl":120,"proxied":false}' | jq .
fi
