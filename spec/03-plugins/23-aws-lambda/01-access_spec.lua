local helpers = require "spec.helpers"

describe("Plugin: AWS Lambda (access)", function()
  local client, api_client

  setup(function()
    helpers.run_migrations()

    local api1 = assert(helpers.dao.apis:insert {
      name         = "lambda.com",
      hosts        = { "lambda.com" },
      upstream_url = helpers.mock_upstream_url,
    })

    local api2 = assert(helpers.dao.apis:insert {
      name         = "lambda2.com",
      hosts        = { "lambda2.com" },
      upstream_url = helpers.mock_upstream_url,
    })

    local api3 = assert(helpers.dao.apis:insert {
      name         = "lambda3.com",
      hosts        = { "lambda3.com" },
      upstream_url = helpers.mock_upstream_url,
    })

    local api4 = assert(helpers.dao.apis:insert {
      name         = "lambda4.com",
      hosts        = { "lambda4.com" },
      upstream_url = helpers.mock_upstream_url,
    })

    local api5 = assert(helpers.dao.apis:insert {
      name         = "lambda5.com",
      hosts        = { "lambda5.com" },
      upstream_url = helpers.mock_upstream_url,
    })

    local api6 = assert(helpers.dao.apis:insert {
      name         = "lambda6.com",
      hosts        = { "lambda6.com" },
      upstream_url = helpers.mock_upstream_url,
    })

    local api7 = assert(helpers.dao.apis:insert {
      name         = "lambda7.com",
      hosts        = { "lambda7.com" },
      upstream_url = helpers.mock_upstream_url,
    })

    local api8 = assert(helpers.dao.apis:insert {
      name         = "lambda8.com",
      hosts        = { "lambda8.com" },
      upstream_url = helpers.mock_upstream_url,
    })

    local api9 = assert(helpers.dao.apis:insert {
      name = "lambda9.com",
      hosts = { "lambda9.com" },
      upstream_url = "http://httpbin.org"
    })

    local api10 = assert(helpers.dao.apis:insert {
      name = "lambda10.com",
      hosts = { "lambda10.com" },
      upstream_url = "http://httpbin.org"
    })

    local api11 = assert(helpers.dao.apis:insert {
      name = "lambda11.com",
      hosts = { "lambda11.com" }
    })

    local api12 = assert(helpers.dao.apis:insert {
      name = "lambda12.com",
      hosts = { "lambda12.com" },
      upstream_url = helpers.mock_upstream_url,
    })

    assert(helpers.dao.plugins:insert {
      name   = "aws-lambda",
      api_id = api1.id,
      config = {
        port          = 10001,
        aws_key       = "mock-key",
        aws_secret    = "mock-secret",
        aws_region    = "us-east-1",
        function_name = "kongLambdaTest",
      },
    })

    assert(helpers.dao.plugins:insert {
      name   = "aws-lambda",
      api_id = api2.id,
      config = {
        port            = 10001,
        aws_key         = "mock-key",
        aws_secret      = "mock-secret",
        aws_region      = "us-east-1",
        function_name   = "kongLambdaTest",
        invocation_type = "Event",
      },
    })

    assert(helpers.dao.plugins:insert {
      name   = "aws-lambda",
      api_id = api3.id,
      config = {
        port            = 10001,
        aws_key         = "mock-key",
        aws_secret      = "mock-secret",
        aws_region      = "us-east-1",
        function_name   = "kongLambdaTest",
        invocation_type = "DryRun",
      },
    })

    assert(helpers.dao.plugins:insert {
      name   = "aws-lambda",
      api_id = api4.id,
      config = {
        port = 10001,
        aws_key       = "mock-key",
        aws_secret    = "mock-secret",
        aws_region    = "us-east-1",
        function_name = "kongLambdaTest",
        timeout       = 100,
      },
    })

    assert(helpers.dao.plugins:insert {
      name   = "aws-lambda",
      api_id = api5.id,
      config = {
        port          = 10001,
        aws_key       = "mock-key",
        aws_secret    = "mock-secret",
        aws_region    = "us-east-1",
        function_name = "functionWithUnhandledError",
      },
    })

    assert(helpers.dao.plugins:insert {
      name   = "aws-lambda",
      api_id = api6.id,
      config = {
        port            = 10001,
        aws_key         = "mock-key",
        aws_secret      = "mock-secret",
        aws_region      = "us-east-1",
        function_name   = "functionWithUnhandledError",
        invocation_type = "Event",
      },
    })

    assert(helpers.dao.plugins:insert {
      name   = "aws-lambda",
      api_id = api7.id,
      config = {
        port = 10001,
        aws_key         = "mock-key",
        aws_secret      = "mock-secret",
        aws_region      = "us-east-1",
        function_name   = "functionWithUnhandledError",
        invocation_type = "DryRun",
      },
    })

    assert(helpers.dao.plugins:insert {
      name   = "aws-lambda",
      api_id = api8.id,
      config = {
        port             = 10001,
        aws_key          = "mock-key",
        aws_secret       = "mock-secret",
        aws_region       = "us-east-1",
        function_name    = "functionWithUnhandledError",
        unhandled_status = 412,
      },
    })
    assert(helpers.dao.plugins:insert {
      name = "aws-lambda",
      api_id = api9.id,
      config = {
        port = 10001,
        aws_key = "mock-key",
        aws_secret = "mock-secret",
        aws_region = "us-east-1",
        function_name = "kongLambdaTest",
        forward_request_method = true,
        forward_request_uri = true,
        forward_request_headers = true,
        forward_request_body = true,
      }
    })

    assert(helpers.dao.plugins:insert {
      name = "aws-lambda",
      api_id = api10.id,
      config = {
        port = 10001,
        aws_key = "mock-key",
        aws_secret = "mock-secret",
        aws_region = "us-east-1",
        function_name = "kongLambdaTest",
        forward_request_method = true,
        forward_request_uri = false,
        forward_request_headers = true,
        forward_request_body = true,
      }
    })

    assert(helpers.dao.plugins:insert {
      name = "aws-lambda",
      api_id = api11.id,
      config = {
        port = 10001,
        aws_key = "mock-key",
        aws_secret = "mock-secret",
        aws_region = "us-east-1",
        function_name = "kongLambdaTest",
        forward_request_method = true,
        forward_request_uri = false,
        forward_request_headers = true,
        forward_request_body = true,
        dynamic_lambda_key = "lambda-key"
      }
    })
    assert(helpers.dao.plugins:insert {
      name   = "aws-lambda",
      api_id = api12.id,
      config = {
        port          = 10001,
        aws_key       = "mock-key",
        aws_secret    = "mock-secret",
        aws_region    = "us-east-1",
        function_name = "functionWithHandledError",
        handled_status_pattern = "Error:([1-9][0-9][0-9])"
      }
    })

    assert(helpers.start_kong{
      nginx_conf = "spec/fixtures/custom_nginx.template",
    })
  end)

  before_each(function()
    client = helpers.proxy_client()
    api_client = helpers.admin_client()
  end)

  after_each(function ()
    client:close()
    api_client:close()
  end)

  teardown(function()
    helpers.stop_kong()
  end)

  it("invokes a Lambda function with GET", function()
    local res = assert(client:send {
      method = "GET",
      path = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
      headers = {
        ["Host"] = "lambda.com"
      }
    })
    assert.res_status(200, res)
    local body = assert.response(res).has.jsonbody()
    assert.is_string(res.headers["x-amzn-RequestId"])
    assert.equal("some_value1", body.key1)
    assert.is_nil(res.headers["X-Amz-Function-Error"])
  end)
  it("invokes a Lambda function with POST params", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post",
      headers = {
        ["Host"] = "lambda.com",
        ["Content-Type"] = "application/x-www-form-urlencoded"
      },
      body = {
        key1 = "some_value_post1",
        key2 = "some_value_post2",
        key3 = "some_value_post3"
      }
    })
    assert.res_status(200, res)
    local body = assert.response(res).has.jsonbody()
    assert.is_string(res.headers["x-amzn-RequestId"])
    assert.equal("some_value_post1", body.key1)
  end)
  it("invokes a Lambda function with POST json body", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post",
      headers = {
        ["Host"] = "lambda.com",
        ["Content-Type"] = "application/json"
      },
      body = {
        key1 = "some_value_json1",
        key2 = "some_value_json2",
        key3 = "some_value_json3"
      }
    })
    assert.res_status(200, res)
    local body = assert.response(res).has.jsonbody()
    assert.is_string(res.headers["x-amzn-RequestId"])
    assert.equal("some_value_json1", body.key1)
  end)
  it("invokes a Lambda function with POST and both querystring and body params", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post?key1=from_querystring",
      headers = {
        ["Host"] = "lambda.com",
        ["Content-Type"] = "application/x-www-form-urlencoded"
      },
      body = {
        key2 = "some_value_post2",
        key3 = "some_value_post3"
      }
    })
    assert.res_status(200, res)
    local body = assert.response(res).has.jsonbody()
    assert.is_string(res.headers["x-amzn-RequestId"])
    assert.equal("from_querystring", body.key1)
  end)
  it("invokes a Lambda function with POST and xml payload, custom header and query partameter", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post?key1=from_querystring",
      headers = {
        ["Host"] = "lambda9.com",
        ["Content-Type"] = "application/xml",
        ["custom-header"] = "someheader"
      },
      body = "<xml/>"
    })
    assert.res_status(200, res)
    local body = assert.response(res).has.jsonbody()
    assert.is_string(res.headers["x-amzn-RequestId"])

    -- request_method
    assert.equal("POST", body.request_method)

    -- request_uri
    assert.equal("/post?key1=from_querystring", body.request_uri)
    assert.is_table(body.request_uri_args)

    -- request_headers
    assert.equal("someheader", body.request_headers["custom-header"])
    assert.equal("lambda9.com", body.request_headers.host)

    -- request_body
    assert.equal("<xml/>", body.request_body)
    assert.is_table(body.request_body_args)
  end)
  it("invokes a Lambda function with POST and json payload, custom header and query partameter", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post?key1=from_querystring",
      headers = {
        ["Host"] = "lambda10.com",
        ["Content-Type"] = "application/json",
        ["custom-header"] = "someheader"
      },
      body = { key2 = "some_value" }
    })
    assert.res_status(200, res)
    local body = assert.response(res).has.jsonbody()
    assert.is_string(res.headers["x-amzn-RequestId"])

    -- request_method
    assert.equal("POST", body.request_method)

    -- no request_uri
    assert.is_nil(body.request_uri)
    assert.is_nil(body.request_uri_args)

    -- request_headers
    assert.equal("lambda10.com", body.request_headers.host)
    assert.equal("someheader", body.request_headers["custom-header"])

    -- request_body
    assert.equal("some_value", body.request_body_args.key2)
    assert.is_table(body.request_body_args)
  end)
  it("invokes a Lambda function with POST and txt payload, custom header and query partameter", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post?key1=from_querystring",
      headers = {
        ["Host"] = "lambda9.com",
        ["Content-Type"] = "text/plain",
        ["custom-header"] = "someheader"
      },
      body = "some text"
    })
    assert.res_status(200, res)
    local body = assert.response(res).has.jsonbody()
    assert.is_string(res.headers["x-amzn-RequestId"])

    -- request_method
    assert.equal("POST", body.request_method)

    -- request_uri
    assert.equal("/post?key1=from_querystring", body.request_uri)
    assert.is_table(body.request_uri_args)

    -- request_headers
    assert.equal("someheader", body.request_headers["custom-header"])
    assert.equal("lambda9.com", body.request_headers.host)

    -- request_body
    assert.equal("some text", body.request_body)
    assert.is_nil(body.request_body_base64)
    assert.is_table(body.request_body_args)
  end)
  it("invokes a Lambda function with POST and binary payload and custom header", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post?key1=from_querystring",
      headers = {
        ["Host"] = "lambda9.com",
        ["Content-Type"] = "application/octet-stream",
        ["custom-header"] = "someheader"
      },
      body = "01234"
    })
    assert.res_status(200, res)
    local body = assert.response(res).has.jsonbody()
    assert.is_string(res.headers["x-amzn-RequestId"])

    -- request_method
    assert.equal("POST", body.request_method)

    -- request_uri
    assert.equal("/post?key1=from_querystring", body.request_uri)
    assert.is_table(body.request_uri_args)

    -- request_headers
    assert.equal("lambda9.com", body.request_headers.host)
    assert.equal("someheader", body.request_headers["custom-header"])

    -- request_body
    assert.equal(ngx.encode_base64('01234'), body.request_body)
    assert.is_true(body.request_body_base64)
    assert.is_table(body.request_body_args)
  end)
  it("invokes a Lambda function with POST params and Event invocation_type", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post",
      headers = {
        ["Host"] = "lambda2.com",
        ["Content-Type"] = "application/x-www-form-urlencoded"
      },
      body = {
        key1 = "some_value_post1",
        key2 = "some_value_post2",
        key3 = "some_value_post3"
      }
    })
    assert.res_status(202, res)
    assert.is_string(res.headers["x-amzn-RequestId"])
  end)
  it("invokes a Lambda function with POST params and DryRun invocation_type", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post",
      headers = {
        ["Host"] = "lambda3.com",
        ["Content-Type"] = "application/x-www-form-urlencoded"
      },
      body = {
        key1 = "some_value_post1",
        key2 = "some_value_post2",
        key3 = "some_value_post3"
      }
    })
    assert.res_status(204, res)
    assert.is_string(res.headers["x-amzn-RequestId"])
  end)
  it("errors on connection timeout", function()
    local res = assert(client:send {
      method = "GET",
      path = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
      headers = {
        ["Host"] = "lambda4.com",
      }
    })
    assert.res_status(500, res)
  end)

  it("invokes a Lambda function with an unhandled function error (and no unhandled_status set)", function()
    local res = assert(client:send {
      method = "GET",
      path = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
      headers = {
        ["Host"] = "lambda5.com"
      }
    })
    assert.res_status(200, res)
    assert.equal("Unhandled", res.headers["X-Amz-Function-Error"])
  end)
  it("invokes a Lambda function with an unhandled function error with Event invocation type", function()
    local res = assert(client:send {
      method = "GET",
      path = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
      headers = {
        ["Host"] = "lambda6.com"
      }
    })
    assert.res_status(202, res)
    assert.equal("Unhandled", res.headers["X-Amz-Function-Error"])
  end)
  it("invokes a Lambda function with an unhandled function error with DryRun invocation type", function()
    local res = assert(client:send {
      method = "GET",
      path = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
      headers = {
        ["Host"] = "lambda7.com"
      }
    })
    assert.res_status(204, res)
    assert.equal("Unhandled", res.headers["X-Amz-Function-Error"])
  end)
  it("invokes a Lambda function with an unhandled function error", function()
    local res = assert(client:send {
      method = "GET",
      path = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
      headers = {
        ["Host"] = "lambda8.com"
      }
    })
    assert.res_status(412, res)
    assert.equal("Unhandled", res.headers["X-Amz-Function-Error"])
  end)
  it("invokes a Lambda function with a dynamic name in header", function()
    local res = assert(client:send {
      method = "GET",
      path = "/get?key1=some_value1&key2=some_value2&key3=some_value3",
      headers = {
        ["Host"] = "lambda11.com",
        ["lambda-key"] = "dynamicLambdaFunction"
      }
    })
    assert.res_status(200, res)
    assert.is_equal("dynamicLambdaFunction", res.headers["x-amzn-RequestId"])
  end)
  it("invokes a Lambda function with a dynamic name in args", function()
    local res = assert(client:send {
      method = "GET",
      path = "/get?lambda-key=dynamicLambdaFunctionArgs",
      headers = {
        ["Host"] = "lambda11.com",
      }
    })
    assert.res_status(200, res)
    assert.is_equal("dynamicLambdaFunctionArgs", res.headers["x-amzn-RequestId"])
  end)
  it("invokes a Lambda function with a dynamic name fall to default", function()
    local res = assert(client:send {
      method = "GET",
      path = "/get?key=value",
      headers = {
        ["Host"] = "lambda11.com",
      }
    })
    assert.res_status(200, res)
    assert.is_equal("kongLambdaTest", res.headers["x-amzn-RequestId"])
  end)
  it("invokes a Lambda function with an handled function error", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post",
      headers = {
        ["Host"] = "lambda12.com",
        ["Content-Type"] = "application/x-www-form-urlencoded"
      },
      body = {
        key1 = "Error:400"
      }
    })
    assert.res_status(400, res)
    assert.equal("Handled", res.headers["X-Amz-Function-Error"])
  end)
  it("invokes a Lambda function with an handled function error", function()
    local res = assert(client:send {
      method = "POST",
      path = "/post",
      headers = {
        ["Host"] = "lambda12.com",
        ["Content-Type"] = "application/x-www-form-urlencoded"
      },
      body = {
        key1 = "value"
      }
    })
    assert.res_status(200, res)
    assert.equal("Handled", res.headers["X-Amz-Function-Error"])
  end)
end)
