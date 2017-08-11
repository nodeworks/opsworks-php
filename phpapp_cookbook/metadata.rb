name        "PHP App Deploy"
description "Deploy applications"
maintainer  "Rob Lee"
license     "Apache 2.0"
version     "1.0.0"

depends "chef_slack"

recipe "deploy_opsworks", "Deploy a PHP application"

