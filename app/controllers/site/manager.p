@USE
controllers/site/interface.p


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

@onINDEX[aRequest]
  $self.title[$core.conf.siteName]
  ^render[/index.pt]

@onNOTFOUND[aRequest]
  $self.title[Страницы не найдена (404)]
  $result[
    $.status[404]
    $.body[^render[/404.pt]]
  ]
