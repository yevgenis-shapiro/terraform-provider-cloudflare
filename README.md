

![with-terraform-_3x-2](https://github.com/user-attachments/assets/20fa14ec-1690-4656-8ceb-adcea4a69fb3)


# Cloudflare
Cloudflare is used to front my website by providing CDN, WAF and DDoS protection.

This directory contains the Terraform IaC to define the Cloudflare configuration.

## Configuration
### Cloudflare
The Cloudflare API key is used to authenticate into my account. Local environmental variable is used:
```
echo 'export CLOUDFLARE_API_KEY="123"' >> ~/.bashrc
echo 'export CLOUDFLARE_EMAIL="myemail@domain.com"' >> ~/.bashrc
```

### Terraform Backend
The Terraform state is stored in AWS S3 alongside with my other IaC.

Note: When I first played with this Cloudflare provider, I was using a local state, but once I added the `backend.tf`, I had to run the following command to migrate my state over to S3. The following commands were used:

```shell
# First auth into AWS
$ export AWS_PROFILE=yevgeni

# Migrate state over to S3
$ terraform init -migrate-state
$ terraform plan
```

## Prerequisites
First setup the zone in Cloudflare
```
terraform init
terraform apply -target cloudflare_zone.lexdsolutions
```

DNS is required to be hosted by Cloudflare. I need to migrate my existing records from AWS Route53 to Cloudflare.

 - Manually port records over to Cloudflare DNS
 - Update DNS registrar to use Cloudflare Name Servers
 - Ensure Top Level domain (lexdsolutions.com) record is **proxied** through CloudFlare

## Deploy Remaining CloudFlare Configuration
This Terraform IaC will configure the remaining settings for this zone, such as enabling cache, WAF and DDoS protections.

```
terraform plan -out tfplan.out
terraform apply tfplan.out
```

### Local Testing
Due to the lag in DNS replication on the internet, to test the Cloudflare protections, I must modify my local `hostfile` to point to the CloudFlare's edge IPs for my DNS.

First get the IP by quering CloudFlare Name Server
```
PC:~$ nslookup
> server bob.ns.cloudflare.com  <------- Set to query Cloudflare
Default server: bob.ns.cloudflare.com
Address: 173.245.59.104#53
Default server: bob.ns.cloudflare.com
Address: 172.64.33.104#53
Default server: bob.ns.cloudflare.com
Address: 108.162.193.104#53

```

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tunnel_secret_value"></a> [tunnel\_secret\_value](#output\_tunnel\_secret\_value) | n/a |
<!-- END_TF_DOCS -->
