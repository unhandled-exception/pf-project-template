@USE
pf2/lib/web/controllers.p


@CLASS
SiteInterfaceModule

@BASE
pfController

@create[aOptions]
## aOptions.core
## aOptions.antiFlood
## aOptions.formater
## aOptions.isDebug(false)
  ^BASE:create[$aOptions]

  $self.isDebug(^aOptions.isDebug.bool(false))
  $self.core[$aOptions.core]

  $self._title[]

@GET_CSQL[]
  $result[$core.CSQL]

@GET_AUTH[]
  $result[$self.request.currentUser.MANAGER]

@SET_title[aTitle]
  $self._title[$aTitle]
  ^assignVar[title;$self._title]

@GET_title[]
  $result[$self._title]

@assignModule[aName;aClassDef;aOptions]
  ^cleanMethodArgument[]
  $aOptions[^hash::create[$aOptions]]
  $aOptions[^aOptions.union[
    $.core[$self.core]
    $.isDebug($self.isDebug)
  ]]
  $result[^BASE:assignModule[$aName;$aClassDef;$aOptions]]

@processRequest[aAction;aRequest;aOptions] -> [$.action[] $.request[] $.prefix[] $.response[]]
  ^if($aRequest.currentUser.isAuthenticated){
    ^authSuccess[$aAction;$aRequest]
  }
  $result[^BASE:processRequest[$aAction;$aRequest;$aOptions]]

@authSuccess[aAction;aRequest]
## Вызываем метод, если пользователь залогинен.
  $result[]

@requireLogin[]
  $result[]
  ^if(!$self.request.currentUser.isAuthenticated){
    ^ROOT.redirectTo[/login]
  }

@require[*aRights]
  $result[]
  ^aRights.foreach[;v]{
    ^if(!^self.request.currentUser.can[$v]){
      ^abort(404)
    }
  }
