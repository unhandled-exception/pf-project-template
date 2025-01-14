@USE
pf2/lib/common.p
models/core.p

@auto[]
  $MAIN:ADMIN_EMAIL[admin@site.ru]
  $MAIN:DEVELOPERS[
    $._default(false)
  ]

  $MAIN:CONF[
    $.host[site.ru]
    $.siteName[Mega site]

    $.connectString[mysql://test:password@localhost/test]

#   Все секретные ключи и пароли надо сгенерировать для каждого проекта отдельно.
#   В unix/linux ключи можно сгенерировать через urandom:
#   > python3 -c "import os, base64; print(base64.b64encode(os.urandom(24)))"
#   И взять символы из результаты работы команды между кавычками.
    $.secretKey[--сгенерировать--]
    $.cryptKey[--сгенерировать--]

    $.antiFlood[
      $.storage[
        $.password[--сгенерировать--]
        $.expires(60*60*8)
      ]
    ]

    $.security[
      $.xframeOptions(true)
      $.stsSeconds(31536000)
      $.contentTypeNosniff(true)
      $.xssFilter(true)

      $.sslRedirect(true)
#       $.sslRedirectExempt[]
    ]

#     $.yandexMetrica[
#       $.counterID[]
#     ]

#   Функции сайта
    $.features[
      $.maintenanceMode(false) ^rem{ Сайт в режиме обслуживания }
#       $.api[]
    ]
  ]

# Если мы хотим временно переопределить в релизе какие-то параметры,
# то прописывем их в файле app/aConfig/local_config.p.
# Например, отключить архив виде или логирование.
# Файл app/config/local_config.p не надо класть в систему контроля версий.

# Пример файла:
# @auto[]
#   $CONF.features.maintenanceMode(true)
#   $DEVELOPERS.[192.168.1.1](true)

  ^pfClass:unsafe{
    ^use[./local_config.p]
  }

@create_app[aConf;aOptions][locals] -> [app manager]
## aOptions.isDebug(false)
  $aOptions[^hash::create[$aOptions]]
  $isDebug(^aOptions.isDebug.bool(false))
  $isMaintenanceMode(^aConf.features.maintenanceMode.bool(false))

  ^use[controllers/site/manager.p]

  $sql[^pfSQLConnection::create[$aConf.connectString;
    $.enableMemoryCache(true)
    $.enableQueriesLog($isDebug)
  ]]

  $core[^Core::create[
    $.conf[$aConf]
    $.sql[$sql]
  ]]

  $managerOptions[
    $.core[$core]
    $.sql[$sql]
    $.formater[$core.formater]
    $.templateFolder[/../../views/site]
    $.isDebug($isDebug)
    $.conf[$aConf]
  ]

  ^if($isMaintenanceMode){
    ^use[controllers/site/maintenance.p]
    $manager[^MaintenanceManager::create[$managerOptions]]
  }{
     $manager[^SiteManager::create[$managerOptions]]
   }

  $result[$manager]
