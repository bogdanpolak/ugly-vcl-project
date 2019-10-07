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
      '  "packets": ['
      '    ['
      '      {'
      
        '        "title": "Design Patterns: Elements of Reusable Object-O' +
        'riented Software",'
      '        "isbn": "978-0201633610",'
      
        '        "author": "Erich Gamma, Richard Helm, Ralph Johnson, Joh' +
        'n Vlissides",'
      '        "date": "Oct 1994",'
      '        "pages": 395,'
      '        "price": 54.9,'
      '        "currency": "USD",'
      
        '        "description": "Modern classic in the literature of obje' +
        'ct-oriented development. Offering timeless and elegant solutions' +
        ' to common problems in software design. It describes 23 patterns' +
        ' for object creation, composing them, and coordinating control f' +
        'low between them.",'
      '        "reviews": ['
      '          {'
      '            "reporter-id": "66666abcdef012",'
      '            "firstname": "Millan",'
      '            "lastname": "Marcus",'
      '            "twitter": "@marusates",'
      '            "linkedin": "in:MillanMarcus",'
      '            "registered": "2019-08-05",'
      '            "rating": 8,'
      
        '            "review": "More than twenty years since the book'#39's p' +
        'ublication it remains incredibly relevant. The preface and intro' +
        'duction are awesome. Some people may have an issue with the age ' +
        'of book. When you read the introduction, they mention that C++ a' +
        'nd Smalltalk are cutting edge programming languages. What I lear' +
        'ned from the book was how Smalltalk was fundamental to creating ' +
        'the MVC (Model-View-Controller) framework. The book'#39's examples a' +
        're mostly about text writing programs, windowing, and drawing. T' +
        'hese examples fit well for the patterns."'
      '          },'
      '          {'
      '            "reporter-id": "234567890abcde",'
      '            "firstname": "Cogdell",'
      '            "lastname": "Torbj'#246'rn",'
      '            "twitter": "@toreloxin",'
      '            "registered": "2019-08-25",'
      '            "rating": 10,'
      
        '            "review": "This book requires sophistication as a pr' +
        'ogrammer. It will be a challenging book for pretty much anyone t' +
        'o understand completely. The glossary was pretty good in this bo' +
        'ok, I would recommend taking a look before you start. The progre' +
        'ssion of the book is excellent. There is a lengthy introduction ' +
        'before getting to the patterns. This helps put the entire book i' +
        'n context and prepares you for the challenge to come. Each patte' +
        'rn is unique in subtle ways that the authors explain masterfully' +
        '."'
      '          }'
      '        ]'
      '      },'
      '      {'
      
        '        "title": "Refactoring: Improving the Design of Existing ' +
        'Code",'
      '        "isbn": "978-0201485677",'
      
        '        "author": "Martin Fowler, Kent Beck, John Brant, William' +
        ' Opdyke, Don Roberts",'
      '        "date": "Jul 1999",'
      '        "pages": 464,'
      '        "price": 52.98,'
      '        "currency": "USD",'
      
        '        "description": "Book shows how refactoring can make obje' +
        'ct-oriented code simpler and easier to maintain. Provides a cata' +
        'log of tips for improving code.",'
      '        "reviews": ['
      '          {'
      '            "reporter-id": "34567890abcdef",'
      '            "firstname": "Willetts",'
      '            "lastname": "T'#225'ng",'
      '            "email": "awilletts1v@abbott.com",'
      '            "registered": "2019-08-12",'
      '            "rating": 9,'
      
        '            "review": "One of those amazing books that every pro' +
        'fessional developer should have on their book shelf.  The author' +
        ' throws you into a small sample application that is poorly desig' +
        'ned and then takes you through a few different refactoring techn' +
        'iques that improve the design of this simple application. Right ' +
        'from the start you see how effective refactoring can be. From th' +
        'ere he goes into topics such as how to detect bad smells in code' +
        '. You also learn a little bit about testing. After the introduct' +
        'ory chapters you begin to dig into a deep catalog of refactoring' +
        's. Each one is named."'
      '          },'
      '          {'
      '            "reporter-id": "4567890abcdef0",'
      '            "firstname": "Mac",'
      '            "lastname": "Ambrosio",'
      '            "registered": "2019-08-15",'
      '            "rating": 8,'
      
        '            "review": "The catalog of refactorings is extremely ' +
        'useful. They are structured so that each refactoring has a name,' +
        ' a motivation, the mechanics and a simple example. This is very ' +
        'effective: step-by-step description of how to carry out the refa' +
        'ctoring and the example shows the refactoring in use. Although t' +
        'he examples are written in Java the book is still very good for ' +
        'any language and any developer."'
      '          }'
      '        ]'
      '      }'
      '    ],'
      '    ['
      '      {'
      '        "title": "Working Effectively with Legacy Code",'
      '        "isbn": "978-0131177055",'
      '        "author": "Michael Feathers",'
      '        "date": "Oct 2004",'
      '        "pages": 464,'
      '        "price": 52.69,'
      '        "currency": "USD",'
      
        '        "description": "This book describes a set of disciplines' +
        ', concepts, and attitudes that you will carry with you for the r' +
        'est of your career and that will help you to turn systems that g' +
        'radually degrade into systems that gradually improve.",'
      '        "reviews": ['
      '          {'
      '            "reporter-id": "34567890abcdef",'
      '            "firstname": "Willetts",'
      '            "lastname": "T'#225'ng",'
      '            "email": "awilletts1v@abbott.com",'
      '            "registered": "2019-08-22",'
      '            "rating": 8,'
      '            "review": "Great book!"'
      '          }'
      '        ]'
      '      },'
      '      {'
      
        '        "title": "Patterns of Enterprise Application Architectur' +
        'e",'
      '        "isbn": "978-0321127426",'
      '        "author": "Martin Fowler",'
      '        "date": "Nov 2002",'
      '        "pages": 560,'
      '        "price": 55.99,'
      '        "currency": "USD",'
      
        '        "description": "This book is written in direct response ' +
        'to the stiff challenges that face enterprise application develop' +
        'ers. Author distills over forty recurring solutions into pattern' +
        's. Indispensable handbook of solutions that are applicable to an' +
        'y enterprise application platform.",'
      '        "reviews": ['
      '          {'
      '            "reporter-id": "567890abcdef01",'
      '            "firstname": "Burberye",'
      '            "lastname": "Na'#235'lle",'
      '            "email": "bburberye7@imgur.com",'
      '            "twitter": "@beearyee",'
      '            "registered": "2019-08-28",'
      '            "rating": 7,'
      
        '            "review": "Book includes great examples that are ver' +
        'y small and simple so even if you fall into this category you sh' +
        'ouldn'#39't have too much of a learning curve. Some of the code is a' +
        ' bit outdated and can be done a bit better now-a-days but what d' +
        'o you expect? This book was written so many years ago! The ideas' +
        ' are still very relevant though, which is what makes this book s' +
        'o timeless."'
      '          }'
      '        ]'
      '      }'
      '    ]'
      '  ]'
      '}'
      '')
    Left = 64
    Top = 40
  end
  object PageProducerBooks2: TPageProducer
    HTMLDoc.Strings = (
      '{'
      '  "packets": ['
      '    ['
      '      {'
      
        '        "title": "Clean Code: A Handbook of Agile Software Craft' +
        'smanship",'
      '        "isbn": "978-0132350884",'
      '        "author": "Robert C. Martin",'
      '        "date": "Aug 2008",'
      '        "pages": 464,'
      '        "price": 47.49,'
      '        "currency": "USD",'
      
        '        "description": "Best agile practices of cleaning code '#39'o' +
        'n the fly'#39' that will instill within you the values of a software' +
        ' craftsman and make you a better programmer'#8212'but only if you work' +
        ' at it.",'
      '        "reviews": ['
      '          {'
      '            "reporter-id": "67890abcdef012",'
      '            "firstname": "Gaia",'
      '            "lastname": "Birchenough",'
      '            "email": "sbirchenough5@bravesites.com",'
      '            "twitter": "@g.birchenough",'
      '            "linkedin": "in:BirchenoughGaia",'
      '            "registered": "2019-09-02",'
      '            "rating": 9,'
      
        '            "review": "I'#39've learned so far, I'#39've become a better' +
        ' and more mature developer. My lead developer recently noticed t' +
        'he positive changes in my code as of late. He was also impressed' +
        ' when I used what I learned to refactor a bit of our code base. ' +
        'Even though it'#39's Java-based and I am a Go developer with a backg' +
        'round that is primarily JS, I'#39've been able to use the ideas in t' +
        'his book to clean up my own code, both personally and profession' +
        'ally."'
      '          },'
      '          {'
      '            "reporter-id": "7890abcdef0123",'
      '            "firstname": "Gar'#231'on",'
      '            "lastname": "Le Sieur",'
      '            "registered": "2019-09-19",'
      '            "rating": 6,'
      
        '            "review": "The content is good, but the soft cover v' +
        'ersion of the book is of a poor print quality, it looks like it ' +
        'was printed from photocopies. It'#39's still readable, but I would n' +
        'ever buy it if I new about the print quality. Should'#39've read oth' +
        'er reviews."'
      '          }'
      '        ]'
      '      },'
      '      {'
      
        '        "title": "Design Patterns: Elements of Reusable Object-O' +
        'riented Software",'
      '        "isbn": "978-0201633610",'
      
        '        "author": "Erich Gamma, Richard Helm, Ralph Johnson, Joh' +
        'n Vlissides",'
      '        "date": "Oct 1994",'
      '        "pages": 395,'
      '        "price": 54.9,'
      '        "currency": "USD",'
      
        '        "description": "Modern classic in the literature of obje' +
        'ct-oriented development. Offering timeless and elegant solutions' +
        ' to common problems in software design. It describes 23 patterns' +
        ' for object creation, composing them, and coordinating control f' +
        'low between them.",'
      '        "reviews": ['
      '          {'
      '            "reporter-id": "66666abcdef012",'
      '            "firstname": "Marcus",'
      '            "lastname": "Millan",'
      '            "twitter": "@marusates",'
      '            "linkedin": "in:MarcusMillan",'
      '            "registered": "2019-09-09",'
      '            "rating": 8,'
      
        '            "review": "I highly recommend this book. If you are ' +
        'a professional developer then buy it without second thought. Thi' +
        's is one of those rare books worth its weight in gold. Authors a' +
        're able to communicate a lot of ideas into a very short amount o' +
        'f space - the book is a bit dense in other words, which is very ' +
        'good in my opinion. They do not beat around the bush and have ve' +
        'ry strong opinions on code quality topics. I have a hard time pu' +
        'tting this books down."'
      '          }'
      '        ]'
      '      },'
      '      {'
      '        "title": "More Coding in Delphi",'
      '        "isbn": "978-1941266106",'
      '        "author": "Nick Hodges",'
      '        "date": "Dec 2015",'
      '        "pages": 246,'
      '        "price": 25.99,'
      '        "currency": "USD",'
      
        '        "description": "Picks up where previous '#39'Coding in Delph' +
        'i'#39' left of, continuing to illustrate good, sound coding techniqu' +
        'es including design patterns and principles.",'
      '        "reviews": ['
      '          {'
      '            "reporter-id": "890abcdef01234",'
      '            "firstname": "Cl'#233'opatre",'
      '            "lastname": "Dansie",'
      '            "registered": "2019-09-11",'
      '            "rating": 6,'
      
        '            "review": "I have been using Delphi for years. I was' +
        ' able go glean some very useful information and understand thing' +
        's better. The author knows his stuff."'
      '          }'
      '        ]'
      '      },'
      '      {'
      '        "title": "Delphi Cookbook - Second Edition",'
      '        "isbn": "978-1785287428",'
      '        "author": "Daniele Teti",'
      '        "date": "Jun 2016",'
      '        "pages": 470,'
      '        "price": 30.13,'
      '        "currency": "EUR",'
      
        '        "description": "Over 60 hands-on recipes to help you mas' +
        'ter the power of Delphi for cross-platform and mobile developmen' +
        't on multiple platforms.",'
      '        "reviews": ['
      '          {'
      '            "firstname": "Karlik",'
      '            "lastname": "Demko",'
      '            "email": "kdemko5@gizmodo.com",'
      '            "twitter": "@kdemko5",'
      '            "linkedin": "in:karlikdemko",'
      '            "registered": "2019-09-14",'
      '            "rating": 8,'
      
        '            "review": "Excellent coverage and examples of many r' +
        'eal-world problems solved simply and elegantly. I have used some' +
        ' of the recipes with great success."'
      '          }'
      '        ]'
      '      }'
      '    ],'
      '    ['
      '      {'
      '        "title": "Delphi High Performance",'
      '        "isbn": "978-1788625456",'
      '        "author": "Primo'#382' Gabrijel'#269'i'#269'",'
      '        "date": "Feb-2018",'
      '        "pages": 336,'
      '        "price": 25.83,'
      '        "currency": "EUR",'
      
        '        "description": "Build fast, scalable, and high performin' +
        'g applications with Delphi.",'
      '        "reviews": ['
      '          {'
      '            "reporter-id": "0abcdef0123456",'
      '            "firstname": "Rui",'
      '            "lastname": "Wallicker",'
      '            "twitter": "@awallicker4",'
      '            "registered": "2019-09-19",'
      '            "rating": 6,'
      
        '            "review": "I appreciate that this book talks both ab' +
        'out responsiveness and computation performance. It is also writt' +
        'en with attention paid to the latest technology, while also bein' +
        'g applicable to earlier versions of Delphi. I learned a lot usef' +
        'ul information and just flipping my programming techiques throug' +
        'h reading this book."'
      '          }'
      '        ]'
      '      },'
      '      {'
      '        "title": "Hands-On Design Patterns with Delphi",'
      '        "isbn": "978-1789343243",'
      '        "author": "Primo'#382' Gabrijel'#269'i'#269'",'
      '        "date": "Feb-2019",'
      '        "pages": 476,'
      '        "price": 35.99,'
      '        "currency": "EUR",'
      
        '        "description": "Build scalable projects via exploring de' +
        'sign patterns in Delphi.",'
      '        "reviews": ['
      '          {'
      '            "reporter-id": "0abcdef0123456",'
      '            "firstname": "Rui",'
      '            "lastname": "Wallicker",'
      '            "twitter": "@awallicker4",'
      '            "registered": "2019-09-24",'
      '            "rating": 6,'
      '            "review": "Book is OK, I like it."'
      '          }'
      '        ]'
      '      }'
      '    ]'
      '  ]'
      '}'
      '')
    Left = 64
    Top = 88
  end
end
