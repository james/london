class Rack::Attack
  # Use Redis for distributed rate limiting across multiple servers
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/1")
  )

  # Throttle all requests by IP
  # Allow 100 requests per minute from a single IP
  throttle('req/ip', limit: 100, period: 1.minute) do |req|
    req.ip
  end

  # Throttle postcode lookups more strictly
  # Allow 30 postcode lookups per minute per IP
  throttle('postcode_lookups/ip', limit: 30, period: 1.minute) do |req|
    if req.path == '/' && req.params['postcode'].present?
      req.ip
    end
  end

  # Exponential backoff for repeat offenders
  # Block IPs that hit the rate limit repeatedly
  blocklist('fail2ban pentesters') do |req|
    # Count requests that got throttled in the last 10 minutes
    Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 5, findtime: 10.minutes, bantime: 1.hour) do
      # Return true if request was throttled
      # This will increment the counter for this IP
      req.env['rack.attack.throttle_data']&.any? { |_name, data| data[:count] > data[:limit] }
    end
  end

  # Always allow requests from localhost (for health checks)
  safelist('allow-localhost') do |req|
    req.ip == '127.0.0.1' || req.ip == '::1'
  end

  # Custom response for throttled requests
  self.throttled_responder = lambda do |env|
    retry_after = env['rack.attack.match_data'][:period]
    [
      429,
      {
        'Content-Type' => 'text/html',
        'Retry-After' => retry_after.to_s
      },
      ["<html><body><h1>Rate limit exceeded</h1><p>Please try again in #{retry_after} seconds.</p></body></html>"]
    ]
  end

  # Custom response for blocked requests
  self.blocklisted_responder = lambda do |_env|
    [
      403,
      { 'Content-Type' => 'text/html' },
      ['<html><body><h1>Forbidden</h1><p>Your IP has been temporarily blocked due to suspicious activity.</p></body></html>']
    ]
  end
end
