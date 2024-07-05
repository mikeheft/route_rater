locals {
  db_password = module.secrets.creds["ROUTE_RATER_DATABASE_PASSWORD"]
}

module "secrets" {
  source = "./secrets"
}

module "elastic_cache" {
  source = "./elastic_cache"
}

module "rds" {
  source      = "./rds"
  db_password = local.db_password
}
module "ebs" {
  source      = "./elastic_beanstalk"
  db_password = local.db_password
  db_endpoint = module.rds.db_endpoint
  redis_host  = module.elastic_cache.redis_address
  redis_port  = module.elastic_cache.redis_port
  depends_on  = [module.elastic_cache.redis, module.rds.route_rater_production]
}
