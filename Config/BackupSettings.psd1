@{
    # SQL parameters section
    SQLBackupFolder = "\\silver\d$\SQL_Backups\it_manage\"
    SQLUser = "sa"
    SQLPasswordPath = ".\SQLPassword.txt"

    # 1C parameters section
    Server1CName = "silver"
    Base1CName = "doc_mgmt"
    PathTo1CExecutable = "c:\Program Files\1cv8\common\1cestart.exe"
    DTPath = "."
    Login1C = "Администратор"
    Password1C = ".\1CPassword.txt"
    
    # FTP parameters section
    WinSCPCom = ".\WinSCP.com"
    WinSCPLog = ".\WinSCP.log"
    FTPPath = "/eisf/private/Минск/БухБазы/"
    FTPSConnectionString = ".\FTPSConnectionString.txt"
}
