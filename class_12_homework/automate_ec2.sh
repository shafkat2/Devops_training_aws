


launch_template_id=$(aws ec2 create-launch-template --launch-template-name TemplateForEncryption --launch-template-data file://launch_template.json | grep -n "LaunchTemplateId" | awk '{print $3}' | grep -o "[a-z].*.[0-9]")

instacne_id=$(aws ec2 run-instances --launch-template $launch_template_id | grep -n "InstanceId" | awk '{print $3}' | grep -o "[a-z].*.[0-9]"))


status=$(aws ec2 describe-instance-status --instance-id $instacne_id | grep -n "code" | awk '{print $3}' | grep -o "[0-9].[0-9]")

while true; do
    status=$(aws ec2 describe-instance-status --instance-id $instacne_id | grep -n "code" | awk '{print $3}' | grep -o "[0-9].[0-9]")
    if ( $status == 16 );then
        break
    fi    
    sleep 10


public_ip=$(aws ec2 describe-intances --instance-ids $instacne_id | grep -n "PublicIp" | awk '{print $3}' | grep -0 "[0-9].*.[0-9]" )

echo $public_ip

sleep 1 min
aws ec2 create-image --instance-id $instacne_id --name "My server" \--description "An AMI for my server test" --no-reboot