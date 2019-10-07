object WebModule1: TWebModule1
  OldCreateOrder = False
  OnCreate = WebModuleCreate
  OnDestroy = WebModuleDestroy
  Actions = <
    item
      Default = True
      Name = 'DefaultHandler'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end>
  Height = 345
  Width = 415
  object PageProducerBooks1: TPageProducer
    HTMLDoc.Strings = (
      '{'
      '"packets":['
      '['
      #9'{'
      
        #9#9'"title": "Design Patterns: Elements of Reusable Object-Oriente' +
        'd Software",'
      #9#9'"isbn": "978-0201633610",'
      
        #9#9'"author": "Erich Gamma, Richard Helm, Ralph Johnson, John Vlis' +
        'sides",'
      #9#9'"date": "Oct 1994",'
      #9#9'"pages": 395,'
      #9#9'"price": 54.9,'
      #9#9'"currency": "USD",'
      
        #9#9'"description": "Modern classic in the literature of object-ori' +
        'ented development. Offering timeless and elegant solutions to co' +
        'mmon problems in software design. It describes 23 patterns for o' +
        'bject creation, composing them, and coordinating control flow be' +
        'tween them.",'
      '                "reviews":'
      '                [{'
      '                        "reporter-id":"66666abcdef012",'
      '                        "firstname":"Millan",'
      '                        "lastname":"Marcus",'
      '                        "twitter":"@marusates",'
      '                        "linkedin":"in:MillanMarcus",'
      '                        "registered":"2018-08-05",'
      '                        "rating":8,'
      
        '                        "review":"More than twenty years since t' +
        'he book'#39's publication it remains incredibly relevant. The prefac' +
        'e and introduction are awesome. Some people may have an issue wi' +
        'th the age of book. When you read the introduction, they mention' +
        ' that C++ and Smalltalk are cutting edge programming languages. ' +
        'What I learned from the book was how Smalltalk was fundamental t' +
        'o creating the MVC (Model-View-Controller) framework. The book'#39's' +
        ' examples are mostly about text writing programs, windowing, and' +
        ' drawing. These examples fit well for the patterns."'
      '                },{'
      '                        "reporter-id":"234567890abcde",'
      '                        "firstname":"Cogdell",'
      '                        "lastname":"Torbj'#246'rn",'
      '                        "twitter":"@toreloxin",'
      '                        "registered":"2018-08-25",'
      '                        "rating":10,'
      
        '                        "review":"This book requires sophisticat' +
        'ion as a programmer. It will be a challenging book for pretty mu' +
        'ch anyone to understand completely. The glossary was pretty good' +
        ' in this book, I would recommend taking a look before you start.' +
        ' The progression of the book is excellent. There is a lengthy in' +
        'troduction before getting to the patterns. This helps put the en' +
        'tire book in context and prepares you for the challenge to come.' +
        ' Each pattern is unique in subtle ways that the authors explain ' +
        'masterfully."'
      '                }]'
      #9'},'
      #9'{'
      #9#9'"title": "Refactoring: Improving the Design of Existing Code",'
      #9#9'"isbn": "978-0201485677",'
      
        #9#9'"author": "Martin Fowler, Kent Beck, John Brant, William Opdyk' +
        'e, Don Roberts",'
      #9#9'"date": "Jul 1999",'
      #9#9'"pages": 464,'
      #9#9'"price": 52.98,'
      #9#9'"currency": "USD",'
      
        #9#9'"description": "Book shows how refactoring can make object-ori' +
        'ented code simpler and easier to maintain. Provides a catalog of' +
        ' tips for improving code.",'
      '                "reviews":'
      '                [{'
      '                        "reporter-id":"34567890abcdef",'
      '                        "firstname":"Willetts",'
      '                        "lastname":"T'#225'ng",'
      '                        "email":"awilletts1v@abbott.com",'
      '                        "registered":"2018-08-12",'
      '                        "rating":9,'
      
        '                        "review":"One of those amazing books tha' +
        't every professional developer should have on their book shelf. ' +
        ' The author throws you into a small sample application that is p' +
        'oorly designed and then takes you through a few different refact' +
        'oring techniques that improve the design of this simple applicat' +
        'ion. Right from the start you see how effective refactoring can ' +
        'be. From there he goes into topics such as how to detect bad sme' +
        'lls in code. You also learn a little bit about testing. After th' +
        'e introductory chapters you begin to dig into a deep catalog of ' +
        'refactorings. Each one is named."'
      '                },{'
      '                        "reporter-id":"4567890abcdef0",'
      '                        "firstname":"Mac",'
      '                        "lastname":"Ambrosio",'
      '                        "registered":"2018-08-15",'
      '                        "rating":8,'
      
        '                        "review":"The catalog of refactorings is' +
        ' extremely useful. They are structured so that each refactoring ' +
        'has a name, a motivation, the mechanics and a simple example. Th' +
        'is is very effective: step-by-step description of how to carry o' +
        'ut the refactoring and the example shows the refactoring in use.' +
        ' Although the examples are written in Java the book is still ver' +
        'y good for any language and any developer."'
      '                }]'
      #9'}'
      '],'
      '['
      #9'{'
      #9#9'"title": "Working Effectively with Legacy Code",'
      #9#9'"isbn": "978-0131177055",'
      #9#9'"author": "Michael Feathers",'
      #9#9'"date": "Oct 2004",'
      #9#9'"pages": 464,'
      #9#9'"price": 52.69,'
      #9#9'"currency": "USD",'
      
        #9#9'"description": "This book describes a set of disciplines, conc' +
        'epts, and attitudes that you will carry with you for the rest of' +
        ' your career and that will help you to turn systems that gradual' +
        'ly degrade into systems that gradually improve.",'
      '                "reviews":'
      '                [{'
      '                        "reporter-id":"34567890abcdef",'
      '                        "firstname":"Willetts",'
      '                        "lastname":"T'#225'ng",'
      '                        "email":"awilletts1v@abbott.com",'
      '                        "registered":"2018-08-22",'
      '                        "rating":8,'
      '                        "review":"Great book!"'
      '                }]'
      #9'},'
      #9'{'
      #9#9'"title": "Patterns of Enterprise Application Architecture",'
      #9#9'"isbn": "978-0321127426",'
      #9#9'"author": "Martin Fowler",'
      #9#9'"date": "Nov 2002",'
      #9#9'"pages": 560,'
      #9#9'"price": 55.99,'
      #9#9'"currency": "USD",'
      
        #9#9'"description": "This book is written in direct response to the' +
        ' stiff challenges that face enterprise application developers. A' +
        'uthor distills over forty recurring solutions into patterns. Ind' +
        'ispensable handbook of solutions that are applicable to any ente' +
        'rprise application platform.",'
      '                "reviews":'
      '                [{'
      '                        "reporter-id":"567890abcdef01",'
      '                        "firstname":"Burberye",'
      '                        "lastname":"Na'#235'lle",'
      '                        "email":"bburberye7@imgur.com",'
      '                        "twitter":"@beearyee",'
      '                        "registered":"2018-08-28",'
      '                        "rating":7,'
      
        '                        "review":"Book includes great examples t' +
        'hat are very small and simple so even if you fall into this cate' +
        'gory you shouldn'#39't have too much of a learning curve. Some of th' +
        'e code is a bit outdated and can be done a bit better now-a-days' +
        ' but what do you expect? This book was written so many years ago' +
        '! The ideas are still very relevant though, which is what makes ' +
        'this book so timeless."'
      '                }]'
      ''
      #9'}'
      ']'
      ']'
      '}')
    Left = 64
    Top = 40
  end
  object PageProducerBooks2: TPageProducer
    HTMLDoc.Strings = (
      '{'
      '"packets":['
      '['
      #9'{'
      
        #9#9'"title": "Clean Code: A Handbook of Agile Software Craftsmansh' +
        'ip",'
      #9#9'"isbn": "978-0132350884",'
      #9#9'"author": "Robert C. Martin",'
      #9#9'"date": "Aug 2008",'
      #9#9'"pages": 464,'
      #9#9'"price": 47.49,'
      #9#9'"currency": "USD",'
      
        #9#9'"description": "Best agile practices of cleaning code '#39'on the ' +
        'fly'#39' that will instill within you the values of a software craft' +
        'sman and make you a better programmer'#8212'but only if you work at it' +
        '.",'
      '                "reviews":'
      '                [{'
      '                        "reporter-id":"67890abcdef012",'
      '                        "firstname":"Birchenough",'
      '                        "lastname":"Gaia",'
      '                        "email":"sbirchenough5@bravesites.com",'
      '                        "twitter":"@b.gaia",'
      '                        "linkedin":"in:BirchenoughGaia",'
      '                        "registered":"2018-09-02",'
      '                        "rating":9,'
      
        '                        "review":"I'#39've learned so far, I'#39've beco' +
        'me a better and more mature developer. My lead developer recentl' +
        'y noticed the positive changes in my code as of late. He was als' +
        'o impressed when I used what I learned to refactor a bit of our ' +
        'code base. Even though it'#39's Java-based and I am a Go developer w' +
        'ith a background that is primarily JS, I'#39've been able to use the' +
        ' ideas in this book to clean up my own code, both personally and' +
        ' professionally."'
      '                },{'
      '                        "reporter-id":"7890abcdef0123",'
      '                        "firstname":"Le Sieur",'
      '                        "lastname":"Gar'#231'on",'
      '                        "registered":"2018-09-19",'
      '                        "rating":6,'
      
        '                        "review":"The content is good, but the s' +
        'oft cover version of the book is of a poor print quality, it loo' +
        'ks like it was printed from photocopies. It'#39's still readable, bu' +
        't I would never buy it if I new about the print quality. Should'#39 +
        've read other reviews."'
      '                }]'
      #9'},'
      #9'{'
      
        #9#9'"title": "Design Patterns: Elements of Reusable Object-Oriente' +
        'd Software",'
      #9#9'"isbn": "978-0201633610",'
      
        #9#9'"author": "Erich Gamma, Richard Helm, Ralph Johnson, John Vlis' +
        'sides",'
      #9#9'"date": "Oct 1994",'
      #9#9'"pages": 395,'
      #9#9'"price": 54.9,'
      #9#9'"currency": "USD",'
      
        #9#9'"description": "Modern classic in the literature of object-ori' +
        'ented development. Offering timeless and elegant solutions to co' +
        'mmon problems in software design. It describes 23 patterns for o' +
        'bject creation, composing them, and coordinating control flow be' +
        'tween them.",'
      '                "reviews":'
      '                [{'
      '                        "reporter-id":"66666abcdef012",'
      '                        "firstname":"Millan",'
      '                        "lastname":"Marcus",'
      '                        "twitter":"@marusates",'
      '                        "linkedin":"in:MillanMarcus",'
      '                        "registered":"2018-09-09",'
      '                        "rating":8,'
      
        '                        "review":"I highly recommend this book. ' +
        'If you are a professional developer then buy it without second t' +
        'hought. This is one of those rare books worth its weight in gold' +
        '. Authors are able to communicate a lot of ideas into a very sho' +
        'rt amount of space - the book is a bit dense in other words, whi' +
        'ch is very good in my opinion. They do not beat around the bush ' +
        'and have very strong opinions on code quality topics. I have a h' +
        'ard time putting this books down."'
      '                }]'
      #9'},'
      #9'{'
      #9#9'"title": "More Coding in Delphi",'
      #9#9'"isbn": "978-1941266106",'
      #9#9'"author": "Nick Hodges",'
      #9#9'"date": "Dec 2015",'
      #9#9'"pages": 246,'
      #9#9'"price": 25.99,'
      #9#9'"currency": "USD",'
      
        #9#9'"description": "Picks up where previous '#39'Coding in Delphi'#39' lef' +
        't of, continuing to illustrate good, sound coding techniques inc' +
        'luding design patterns and principles.",'
      '                "reviews":'
      '                [{'
      '                        "reporter-id":"890abcdef01234",'
      '                        "firstname":"A",'
      '                        "lastname":"A",'
      '                        "registered":"2018-09-11",'
      '                        "rating":6,'
      '                        "review":"AAAA aaaa AAAA aaaaaa."'
      '                }]'
      #9'},'
      #9'{'
      #9#9'"title": "Delphi Cookbook - Second Edition",'
      #9#9'"isbn": "978-1785287428",'
      #9#9'"author": "Daniele Teti",'
      #9#9'"date": "Jun 2016",'
      #9#9'"pages": 470,'
      #9#9'"price": 30.13,'
      #9#9'"currency": "EUR",'
      
        #9#9'"description": "Over 60 hands-on recipes to help you master th' +
        'e power of Delphi for cross-platform and mobile development on m' +
        'ultiple platforms.",'
      '                "reviews":'
      '                [{'
      '                        "reporter-id":"90abcdef012345",'
      '                        "firstname":"BBBB",'
      '                        "lastname":"BB",'
      '                        "registered":"2018-09-14",'
      '                        "rating":6,'
      '                        "review":"BBBBB BBB BB BBBB"'
      '                }]'
      ''
      #9'}'
      '],'
      '['
      #9'{'
      #9#9'"title": "Delphi High Performance",'
      #9#9'"isbn": "978-1788625456",'
      #9#9'"author": "Primo'#382' Gabrijel'#269'i'#269'",'
      #9#9'"date": "Feb-2018",'
      #9#9'"pages": 336,'
      #9#9'"price": 25.83,'
      #9#9'"currency": "EUR",'
      
        #9#9'"description": "Build fast, scalable, and high performing appl' +
        'ications with Delphi.",'
      '                "reviews":'
      '                [{'
      '                        "reporter-id":"0abcdef0123456",'
      '                        "firstname":"C",'
      '                        "lastname":"C",'
      '                        "registered":"2018-09-19",'
      '                        "rating":6,'
      '                        "review":"C"'
      '                }]'
      #9'},'
      #9'{'
      #9#9'"title": "Hands-On Design Patterns with Delphi",'
      #9#9'"isbn": "978-1789343243",'
      #9#9'"author": "Primo'#382' Gabrijel'#269'i'#269'",'
      #9#9'"date": "Feb-2019",'
      #9#9'"pages": 476,'
      #9#9'"price": 35.99,'
      #9#9'"currency": "EUR",'
      
        #9#9'"description": "Build scalable projects via exploring design p' +
        'atterns in Delphi.",'
      '                "reviews":'
      '                [{'
      '                        "reporter-id":"0abcdef0123456",'
      '                        "firstname":"D",'
      '                        "lastname":"D",'
      '                        "registered":"2018-09-24",'
      '                        "rating":6,'
      '                        "review":"D"'
      '                }]'
      #9'}'
      ']'
      ']'
      '}')
    Left = 64
    Top = 88
  end
  object PageTemplate1: TPageProducer
    HTMLDoc.Strings = (
      '['
      #9'{'
      #9#9'"status": "avaliable",'
      #9#9'"title": "",'
      #9#9'"isbn": "",'
      #9#9'"author": "",'
      #9#9'"date": "",'
      #9#9'"pages": ,'
      #9#9'"price": ,'
      #9#9'"currency": "",'
      #9#9'"description": ""'
      #9'},'
      #9'{'
      #9#9'"status": "avaliable",'
      #9#9'"title": "",'
      #9#9'"isbn": "",'
      #9#9'"author": "",'
      #9#9'"date": "",'
      #9#9'"pages": ,'
      #9#9'"price": ,'
      #9#9'"currency": "",'
      #9#9'"description": ""'
      #9'}'
      ']')
    Left = 64
    Top = 240
  end
end
