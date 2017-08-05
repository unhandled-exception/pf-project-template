@USE
controllers/site/interface.p
pf2/lib/web/middleware.p


@CLASS
SiteManager

@BASE
SiteInterfaceModule

@OPTIONS
locals

@create[aOptions]
## aOptions.conf
  ^BASE:create[
    ^hash::create[$aOptions]
    $.asManager(true)
  ]
  $self.conf[$aOptions.conf]

  ^router.middleware[pfDebugInfoMiddleware;
    $.enable($self.isDebug)
    $.sql[$core.CSQL]
    $.enableHighlightJS(true)
#   $.hideQueryLog(true)
  ]
  ^router.middleware[pf2/lib/web/csrf.p@pfCSRFMiddleware;
    $.cryptoProvider[$core.security]
    $.cookieSecure(true)
  ]
  ^router.middleware[pfSecurityMiddleware;$aConf.security]
  ^router.middleware[pfCommonMiddleware;
    $.disableHTTPCache(true)
#     $.appendSlash(true)
  ]

@/[aRequest]
  $self.title[$core.conf.siteName]
  ^render[/index.pt]

@catch<http.404>[aRequest]
  $self.title[Страницы не найдена (404)]
  $result[
    $.status[404]
    $.body[^render[/404.pt]]
  ]
