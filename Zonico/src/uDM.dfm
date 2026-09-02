object DM: TDM
  OnCreate = DataModuleCreate
  Height = 200
  Width = 300
  object Conn: TFDConnection
    LoginPrompt = False
    Left = 32
    Top = 24
  end
  object DriverLink: TFDPhysFBDriverLink
    Left = 120
    Top = 24
  end
  object WaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 208
    Top = 24
  end
end
