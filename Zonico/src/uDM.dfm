object dmZonico: TdmZonico
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 300
  Width = 400
  object conZonico: TFDConnection
    LoginPrompt = False
    Left = 48
    Top = 32
  end
  object drvFirebird: TFDPhysFBDriverLink
    Left = 168
    Top = 32
  end
  object guiWait: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 280
    Top = 32
  end
  object qryZone: TFDQuery
    Connection = conZonico
    Left = 48
    Top = 112
  end
  object dsZone: TDataSource
    DataSet = qryZone
    Left = 168
    Top = 112
  end
end
