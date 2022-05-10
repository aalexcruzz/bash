# Create Metric for alarm Certificate Expiration Day 
This script create a metric in aws cloudwatch for monitoring certificate expiration day 

## How to use
In a ec2 instance where use a key repository add this file in a scheduled task (crontab), change this parameters **AliasName** and **MetricName** for certificate you are going to monitor.

```
#Crontab 
0 */10 * * * /opt/services/CertificateExpirationDay.sh AliasName MetricName
```

Once these parameters are defined, depending on the selected attack mode... everything necessary will be displayed automatically.
