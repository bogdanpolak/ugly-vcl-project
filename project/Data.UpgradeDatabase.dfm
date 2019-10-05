object UpgradeDataModule: TUpgradeDataModule
  OldCreateOrder = False
  Height = 150
  Width = 297
  object FDScriptBuild2001: TFDScript
    SQLScripts = <
      item
        Name = 'StructureAndData'
        SQL.Strings = (
          'BEGIN TRANSACTION;'
          'CREATE TABLE IF NOT EXISTS "DBInfo" ('
          #9'"VersionNr"'#9'INTEGER'
          ');'
          'CREATE TABLE IF NOT EXISTS "Reports" ('
          #9'"ReaderId"'#9'INTEGER,'
          #9'"ISBN"'#9'NVARCHAR(20) NOT NULL,'
          #9'"Rating"'#9'INTEGER,'
          #9'"Oppinion"'#9'NVARCHAR(2000),'
          #9'"Reported"'#9'DATETIME,'
          #9'FOREIGN KEY("ISBN") REFERENCES "Books"("ISBN")'
          ');'
          'CREATE TABLE IF NOT EXISTS "Readers" ('
          #9'"ReaderId"'#9'INTEGER NOT NULL,'
          #9'"FirstName"'#9'NVARCHAR(100),'
          #9'"LastName"'#9'NVARCHAR(100),'
          #9'"Email"'#9'NVARCHAR(50),'
          #9'"Company"'#9'NVARCHAR(100),'
          #9'"BooksRead"'#9'INTEGER,'
          #9'"LastReport"'#9'DATETIME,'
          #9'"Created"'#9'DATETIME,'
          #9'PRIMARY KEY("ReaderId")'
          ');'
          'CREATE TABLE IF NOT EXISTS "Books" ('
          #9'"ISBN"'#9'NVARCHAR(20) NOT NULL,'
          #9'"Title"'#9'NVARCHAR(100) NOT NULL,'
          #9'"Authors"'#9'NVARCHAR(100),'
          #9'"Status"'#9'NVARCHAR(15) NOT NULL,'
          #9'"ReleseDate"'#9'DATE,'
          #9'"Pages"'#9'INTEGER,'
          #9'"Price"'#9'DECIMAL(12 , 2),'
          #9'"Currency"'#9'NVARCHAR(10),'
          #9'"Imported"'#9'DATETIME,'
          #9'"Description"'#9'NVARCHAR(2000),'
          #9'PRIMARY KEY("ISBN")'
          ');'
          'COMMIT;'
          'BEGIN TRANSACTION;'
          
            'INSERT INTO "Books" VALUES ('#39'978-1941266229'#39','#39'Dependency Injecti' +
            'on In Delphi'#39','#39'Nick Hodges'#39','#39'on-shelf'#39','#39'2017-02-01'#39',132,18.18,'#39'U' +
            'SD'#39','#39'2017-12-23'#39','#39'Covers Dependency Injection, you'#39#39'll learn abo' +
            'ut Constructor Injection, Property Injection, and Method Injecti' +
            'on and about the right and wrong way to use it'#39');'
          
            'INSERT INTO "Books" VALUES ('#39'978-1788621304'#39','#39'Delphi Cookbook - ' +
            'Third Edition'#39','#39'Daniele Spinetti, Daniele Teti'#39','#39'avaliable'#39','#39'201' +
            '8-07-01'#39',668,30.13,'#39'EUR'#39','#39'2018-03-24'#39','#39'Quickly learn and employ ' +
            'practical recipes for developing real-world, cross-platform appl' +
            'ications using Delphi'#39');'
          
            'INSERT INTO "Books" VALUES ('#39'978-1941266038'#39','#39'Coding in Delphi'#39',' +
            #39'Nick Hodges'#39','#39'on-shelf'#39','#39'2014-04-01'#39',236,24.99,'#39'USD'#39','#39'2017-10-0' +
            '5'#39','#39'All about writing Delphi code. It'#39#39's just about how to use t' +
            'he language in the most effective way to write clean, testable, ' +
            'maintainable Delphi code'#39');'
          
            'INSERT INTO "Books" VALUES ('#39'978-1786466150'#39','#39'.NET Design Patter' +
            'ns'#39','#39'Praseed Pai, Shine Xavier'#39','#39'on-shelf'#39','#39'2017-01-01'#39',314,26.6' +
            '9,'#39'EUR'#39','#39'2017-10-27'#39','#39'Explore the world of .NET design patterns ' +
            'and bring the benefits that the right patterns can offer to your' +
            ' toolkit today'#39');'
          
            'INSERT INTO "Books" VALUES ('#39'978-1786460165'#39','#39'Expert Delphi'#39','#39'Pa' +
            'we'#322' G'#322'owacki'#39','#39'on-shelf'#39','#39'2017-06-01'#39',506,32.71,'#39'EUR'#39','#39'2017-12-1' +
            '2'#39','#39'Become a developer superhero and build stunning cross-platfo' +
            'rm apps with Delphi'#39');'
          
            'INSERT INTO "Books" VALUES ('#39'978-1546391272'#39','#39'Delphi in Depth: F' +
            'ireDAC'#39','#39'Cary Jensen Ph.D'#39','#39'avaliable'#39','#39'2017-05-01'#39',556,52.43,'#39'E' +
            'UR'#39','#39'2017-12-21'#39','#39'Learn how to connect to a wide variety of data' +
            'bases, optimize your connection configurations, the power of per' +
            'sisted datasets, create flexible queries using macros and FireDA' +
            'C scalar functions, achieve blazing performance with Array DML, ' +
            'Master the art of cached updates'#39');'
          
            'INSERT INTO "Readers" VALUES (1,'#39'Routledge'#39','#39'Ned'#39','#39'nroutledge2j@' +
            'europa.eu'#39','#39'Stamm, Cassin and Bins'#39',1,'#39'2018-04-10'#39','#39'2017-09-15'#39')' +
            ';'
          
            'INSERT INTO "Readers" VALUES (2,'#39'Sobieraj'#39','#39'Stanis'#322'aw'#39','#39'staszek.' +
            'sobieraj@empik.com'#39','#39'Empik sp. z o.o.'#39',1,'#39'2018-06-10'#39','#39'2017-11-2' +
            '3'#39');'
          
            'INSERT INTO "Readers" VALUES (3,'#39'Gervasio'#39','#39'Brancato'#39','#39'rervasio3' +
            '419@email.it'#39','#39'Komerci'#39',1,'#39'2018-08-15 22:12:31.000'#39','#39'2019-02-16 ' +
            '22:20:16.515'#39');'
          
            'INSERT INTO "Readers" VALUES (4,'#39'Rolando'#39','#39'D'#39#39'Ottavio'#39','#39'r.ottavi' +
            'o@alice.it'#39','#39'Motife Srl'#39',1,'#39'2018-08-23 12:02:17.000'#39','#39'2019-02-16' +
            ' 22:20:16.516'#39');'
          
            'INSERT INTO "Readers" VALUES (5,'#39'Adolfo'#39','#39'Alba'#39','#39'aa9876543@gmail' +
            '.com'#39','#39#39',1,'#39'2018-09-02 21:55:43.000'#39','#39'2019-02-16 22:20:16.517'#39');'
          
            'INSERT INTO "Readers" VALUES (6,'#39'Pancrazio'#39','#39'Muto'#39','#39'SuperPancraz' +
            'io70@email.it'#39','#39#39',1,'#39'2018-09-15 00:32:31.000'#39','#39'2019-02-16 22:20:' +
            '16.518'#39');'
          
            'INSERT INTO "Readers" VALUES (7,'#39'Owbridge'#39','#39'Ian'#39','#39'iowbridge1v@jo' +
            'omla.org'#39','#39#39',1,'#39'2018-09-28 01:02:21.000'#39','#39'2019-02-16 22:20:16.51' +
            '9'#39');'
          
            'INSERT INTO "Reports" VALUES (1,'#39'978-1941266229'#39',9,'#39'Nick'#39#39's pers' +
            'pective on developing modern Delphi code and his methodologies h' +
            'ave really made a difference in our team.'#39','#39'2018-09-20 17:39:49.' +
            '000'#39');'
          
            'INSERT INTO "Reports" VALUES (2,'#39'978-1788621304'#39',10,'#39'Great! Ther' +
            'e are lots of an easy to implement recepies. Very useful for the' +
            ' future. I recommend it to an every Delphi developer.'#39','#39'2018-07-' +
            '27 20:30:49.000'#39');'
          
            'INSERT INTO "Reports" VALUES (3,'#39'978-1941266038'#39',9,'#39'This must-re' +
            'ad book highlights the importance writung of clean and resposibl' +
            'e code in Delphi.'#39','#39'2018-08-15 22:12:31.000'#39');'
          
            'INSERT INTO "Reports" VALUES (4,'#39'978-1786466150'#39',8,'#39'This is the ' +
            'key to making things done and getting the results.'#39','#39'2018-08-23 ' +
            '12:02:17.000'#39');'
          
            'INSERT INTO "Reports" VALUES (5,'#39'978-1786460165'#39',7,'#39'The tools an' +
            'd insights author shares in his book have been instrumental in e' +
            'levating my development knowledge.'#39','#39'2018-09-02 21:55:43.000'#39');'
          
            'INSERT INTO "Reports" VALUES (6,'#39'978-1546391272'#39',8,'#39'It'#8217's require' +
            'd reading for any developer looking to play with FireDAC'#39','#39'2018-' +
            '09-15 00:32:31.000'#39');'
          
            'INSERT INTO "Reports" VALUES (7,'#39'978-1788621304'#39',10,'#39'Daniele'#8217's s' +
            'mart and thoughtful approach showing small and extremely useful ' +
            'recipes was the best reading for me.'#39','#39'2018-09-28 01:02:21.000'#39')' +
            ';'
          'INSERT INTO "DBInfo" VALUES (2001);'
          'COMMIT;'
          '')
      end>
    Params = <>
    Macros = <>
    Left = 40
    Top = 16
  end
end
