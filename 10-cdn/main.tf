resource "aws_cloudfront_distribution" "mechanoidstore" {
  enabled             = true
  aliases             = ["web-${var.tags.Component}.${var.dns}"]
  origin {
    domain_name = "web-${var.environment}.${var.dns}"
    origin_id   = "web-${var.environment}.${var.dns}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  ordered_cache_behavior {
    path_pattern     = "/images/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "web-${var.environment}.${var.dns}"

    cache_policy_id = data.aws_cloudfront_cache_policy.cache.id
    compress               = true
    viewer_protocol_policy = "https-only"
  }

  ordered_cache_behavior {
  path_pattern     = "/static/*"
  allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  cached_methods   = ["GET", "HEAD", "OPTIONS"]
  target_origin_id = "web-${var.environment}.${var.dns}"

  cache_policy_id = data.aws_cloudfront_cache_policy.cache.id
  compress               = true
  viewer_protocol_policy = "https-only"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "web-${var.environment}.${var.dns}"
    viewer_protocol_policy = "https-only" # other options - https only, http
    cache_policy_id = data.aws_cloudfront_cache_policy.no_cache.id
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"]
    }
  }
  tags = merge(
    var.common_tags,
    var.tags
  )
  viewer_certificate {
    acm_certificate_arn      = data.aws_ssm_parameter.acm_certificate_arn.value
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.dns

  records = [
    {
      name    = "web-cdn"
      type    = "A"
      alias   = {
        name    = aws_cloudfront_distribution.mechanoidstore.domain_name
        zone_id = aws_cloudfront_distribution.mechanoidstore.hosted_zone_id
      }
    }
  ]
}