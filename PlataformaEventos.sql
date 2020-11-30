DROP VIEW IF EXISTS  ParticipantesBrasileirosInadimplentes;
DROP TABLE IF EXISTS Organizacao;
DROP TABLE IF EXISTS Conducao;
DROP TABLE IF EXISTS Inscricao;
DROP TABLE IF EXISTS Interesse;
DROP TABLE IF EXISTS Pertence;
DROP TABLE IF EXISTS Validacao;
DROP TABLE IF EXISTS Contratacao;

DROP TABLE IF EXISTS Servico;
DROP TABLE IF EXISTS Telefone; 
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS Certificado;
DROP TABLE IF EXISTS Categoria;
DROP TABLE IF EXISTS Evento;
DROP TABLE IF EXISTS Organizador;
DROP TABLE IF EXISTS Condutor;
DROP TABLE IF EXISTS Participante;
DROP TABLE IF EXISTS Usuario;
DROP TABLE IF EXISTS Endereco;



CREATE TABLE Usuario ( 
 idUsuario SERIAL PRIMARY KEY NOT NULL,
 cpf CHAR(11) UNIQUE NOT NULL,
 nome VARCHAR(60) NOT NULL,
 email VARCHAR(60) UNIQUE NOT NULL,
 senha VARCHAR(60) NOT NULL,
 idEnderecoUsuario INTEGER NOT NULL
); 

CREATE TABLE Organizador ( 
 compr_ident VARCHAR(200) NOT NULL,
 compr_end VARCHAR(200) NOT NULL,
 idUsuario INTEGER PRIMARY KEY NOT NULL
); 

CREATE TABLE Condutor ( 
 tipo_condutor VARCHAR(30) NOT NULL,
 associacao VARCHAR(60),
 idUsuario INTEGER PRIMARY KEY NOT NULL
); 

CREATE TABLE Participante ( 
 idUsuario INTEGER PRIMARY KEY NOT NULL
); 

CREATE TABLE Endereco (
 idEndereco SERIAL PRIMARY KEY NOT NULL,
 rua VARCHAR(40) NOT NULL,
 num VARCHAR(6) NOT NULL,
 bairro VARCHAR(40) NOT NULL,
 cep VARCHAR(9) NOT NULL,
 cidade VARCHAR(40) NOT NULL,
 estado VARCHAR(30) NOT NULL,
 pais VARCHAR(40) NOT NULL,
 tipo_end VARCHAR(7) NOT NULL,
 CHECK(tipo_end IN('usuário', 'evento'))
); 

CREATE TABLE Telefone (
 idTelefone SERIAL PRIMARY KEY NOT NULL,  
 num_tel VARCHAR(15) NOT NULL,
 idUsuario INTEGER NOT NULL
); 

CREATE TABLE Funcionario (
 idFuncionario SERIAL PRIMARY KEY NOT NULL,
 nome VARCHAR(60) NOT NULL,
 setor VARCHAR(30) NOT NULL,
 chefe VARCHAR(30) NOT NULL
);

CREATE TABLE Certificado (
 idCertificado SERIAL PRIMARY KEY NOT NULL,
 carga_hr NUMERIC NOT NULL,
 tipo_cert VARCHAR(12) NOT NULL,
 data_hora_emissao TIMESTAMP WITH TIME ZONE NOT NULL,
 autenticacao_eletr VARCHAR(30) UNIQUE NOT NULL,
 idUsuario INTEGER,
 idEvento INTEGER,
 CHECK(tipo_cert IN('organização', 'condução', 'participação'))
); 

CREATE TABLE Categoria (
 idCategoria SERIAL PRIMARY KEY NOT NULL,
 nome VARCHAR(40) NOT NULL,
 area VARCHAR(40) NOT NULL,
 UNIQUE(nome, area)
);

CREATE TABLE Evento (
 idEvento SERIAL PRIMARY KEY NOT NULL,
 nome VARCHAR(60) NOT NULL,
 valor NUMERIC,
 data_hora_realizacao TIMESTAMP WITH TIME ZONE NOT NULL,
 data_hora_criacao TIMESTAMP WITH TIME ZONE NOT NULL,
 privacidade VARCHAR(7) NOT NULL,
 idEnderecoEvento INTEGER NOT NULL,
 CHECK(privacidade IN('público', 'privado'))
);

CREATE TABLE Servico ( 
 idServico SERIAL PRIMARY KEY NOT NULL,
 nome VARCHAR(60) NOT NULL,
 empresa VARCHAR(30) NOT NULL,
 descricao VARCHAR(100),
 UNIQUE(nome, empresa)
);

CREATE TABLE Organizacao (
 idOrganizador INTEGER NOT NULL,
 idEvento INTEGER NOT NULL,
 PRIMARY KEY(idOrganizador, idEvento)
); 

CREATE TABLE Conducao (
 idCondutor INTEGER NOT NULL,
 idEvento INTEGER NOT NULL,
 PRIMARY KEY(idCondutor, idEvento)
);

CREATE TABLE Inscricao (
 idParticipante INTEGER NOT NULL,
 idEvento INTEGER NOT NULL,
 num_inscricao SERIAL UNIQUE,
 situacao VARCHAR(8),
 PRIMARY KEY(idParticipante, idEvento),
 CHECK(situacao IN('pendente', 'pago'))
); 

CREATE TABLE Interesse (
 idParticipante INTEGER NOT NULL,
 idCategoria INTEGER NOT NULL,
 PRIMARY KEY(idParticipante, idCategoria)
); 

CREATE TABLE Pertence (
 idCategoria INTEGER NOT NULL,
 idEvento INTEGER NOT NULL,
 PRIMARY KEY(idCategoria, idEvento)
);

CREATE TABLE Validacao (
 idFuncionario INTEGER,
 idOrganizador INTEGER NOT NULL,
 data_hora TIMESTAMP WITH TIME ZONE NOT NULL,
 aprovado BOOLEAN,
 PRIMARY KEY(data_hora, idOrganizador)
);

CREATE TABLE Contratacao (
 idEvento INTEGER NOT NULL,
 idServico INTEGER NOT NULL,
 data_hora_contratacao TIMESTAMP WITH TIME ZONE NOT NULL,
 PRIMARY KEY(idEvento, idServico)
); 

ALTER TABLE Usuario ADD FOREIGN KEY(idEnderecoUsuario) REFERENCES Endereco (idEndereco) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Organizador ADD FOREIGN KEY(idUsuario) REFERENCES Usuario (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Condutor ADD FOREIGN KEY(idUsuario) REFERENCES Usuario (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Participante ADD FOREIGN KEY(idUsuario) REFERENCES Usuario (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Telefone ADD FOREIGN KEY(idUsuario) REFERENCES Usuario (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Certificado ADD FOREIGN KEY(idUsuario) REFERENCES Usuario (idUsuario) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Certificado ADD FOREIGN KEY(idEvento) REFERENCES Evento (idEvento) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Evento ADD FOREIGN KEY(idEnderecoEvento) REFERENCES Endereco (idEndereco) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Organizacao ADD FOREIGN KEY(idOrganizador) REFERENCES Organizador (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Organizacao ADD FOREIGN KEY(idEvento) REFERENCES Evento (idEvento) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Conducao ADD FOREIGN KEY(idCondutor) REFERENCES Condutor (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Conducao ADD FOREIGN KEY(idEvento) REFERENCES Evento (idEvento) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Inscricao ADD FOREIGN KEY(idParticipante) REFERENCES Participante (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Inscricao ADD FOREIGN KEY(idEvento) REFERENCES Evento (idEvento) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Interesse ADD FOREIGN KEY(idParticipante) REFERENCES Participante (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Interesse ADD FOREIGN KEY(idCategoria) REFERENCES Categoria (idCategoria) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Pertence ADD FOREIGN KEY(idCategoria) REFERENCES Categoria (idCategoria) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Pertence ADD FOREIGN KEY(idEvento) REFERENCES Evento (idEvento) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Validacao ADD FOREIGN KEY(idFuncionario) REFERENCES Funcionario (idFuncionario) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Validacao ADD FOREIGN KEY(idOrganizador) REFERENCES Organizador (idUsuario) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Contratacao ADD FOREIGN KEY(idEvento) REFERENCES Evento (idEvento) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Contratacao ADD FOREIGN KEY(idServico) REFERENCES Servico (idServico) ON DELETE CASCADE ON UPDATE CASCADE;

-- Inserindo Endereços (100)
---- De usuários
INSERT INTO Endereco (rua,num,bairro,cep,cidade,pais,estado,tipo_end) VALUES ('Ap #997-3365 Elementum, Ave','754','BR','065383960','Sasaram','Montserrat','Hatay','usuário'),('P.O. Box 931, 3275 Mauris Road','385','Bolívar','761291101','Magangué','Djibouti','Vologda Oblast','usuário'),('Ap #861-5002 Ut St.','183','MA','465311500','Alcalá de Henares','Antarctica','L','usuário'),('567-5761 Eget Avenue','654','Vlaams-Brabant','219722490','Itterbeek','Libya','Metropolitana de Santiago','usuário'),('154-266 Ut Road','961','ON','401481516','Cornwall','Oman','WA','usuário'),('621-7750 Sem Street','037','Berlin','140575452','Berlin','Germany','Connacht','usuário'),('Ap #794-8057 Aenean Street','704','AB','539783362','Hines Creek','United States Minor Outlying Islands','NW','usuário'),('129-7699 Aenean Rd.','619','Central Java','264606659','Semarang','Iran','Vienna','usuário'),('P.O. Box 483, 2823 A Rd.','195','Gangwon','187046570','Gangneung','Kyrgyzstan','Chi','usuário'),('6290 Id, Street','913','Gye','372279716','Hanam','Venezuela','CM','usuário');
INSERT INTO Endereco (rua,num,bairro,cep,cidade,pais,estado,tipo_end) VALUES ('Ap #204-4166 Nascetur Rd.','286','VGG','748191792','Volgograd','Finland','Zl','usuário'),('Ap #715-7647 Vivamus St.','167','Leinster','514531837','Dublin','Malawi','PM','usuário'),('Ap #487-7771 Amet Rd.','070','LIM','410278097','Lima','South Georgia and The South','Wisconsin','usuário'),('Ap #312-415 Aliquam Avenue','228','Jal','825594230','Zapopan','Qatar','Khyber Pakhtoonkhwa','usuário'),('752-3101 Tortor Rd.','893','LAL','128870263','Trujillo','Bahrain','Gye','usuário'),('6954 Tincidunt, Street','631','ANT','499948030','Envigado','French Southern Territories','Istanbul','usuário'),('768-8777 Nam Ave','743','Veracruz','449810585','Poza Rica','Cuba','Minas Gerais','usuário'),('357-4354 Nibh. Av.','853','BC','942647653','Sparwood','Mayotte','H','usuário'),('3804 Lacus. Rd.','489','Ontario','926493778','Minto','Monaco','RS','usuário'),('P.O. Box 225, 1245 Justo. Rd.','883','Alajuela','689739189','Quesada','Sao Tome and Principe','Gujarat','usuário');
INSERT INTO Endereco (rua,num,bairro,cep,cidade,pais,estado,tipo_end) VALUES ('886-246 Justo Rd.','085','South Chungcheong','574871006','Daejeon','Denmark','NI','usuário'),('7158 Fusce Avenue','100','CA','750626174','Sabadell','Palestine, State of','Wie','usuário'),('Ap #273-2454 Cras St.','021','PV','379913620','Gasteiz','Ethiopia','Namen','usuário'),('198-2371 Pharetra. Avenue','501','B.C','334247936','La Paz','South Africa','KA','usuário'),('P.O. Box 698, 6432 Cubilia St.','593','North Island','076150836','Waiuku','Saint Helena, Ascension','Friesland','usuário'),('Rua Bertholdo Tavares Filho','624','Residencial Village Campo Novo','630457014','Bauru','Brasil','SP','usuário'),('4751 Malesuada. Road','153','DS','270308996','Wrocław','Turkmenistan','Pomorskie','usuário'),('763-9021 Lorem, Ave','415','ARE','386643637','Arequipa','Japan','IX','usuário'),('Ap #386-5768 Velit. St.','543','SJ','525778801','San Pedro','Taiwan','Missouri','usuário'),('969-5203 Parturient St.','999','Luik','295093839','Herstal','Western Sahara','Queensland','usuário');
INSERT INTO Endereco (rua,num,bairro,cep,cidade,pais,estado,tipo_end) VALUES ('Ap #581-4034 Erat Street','552','São Paulo','140323747','Ribeirão Preto','Barbados','Arkansas','usuário'),('Ap #940-1023 Egestas Av.','682','H','770149042','Mercedes','Kiribati','Toscana','usuário'),('Ap #435-2589 Ipsum. St.','717','ARE','667672161','Arequipa','Turkey','Antioquia','usuário'),('Ap #508-3975 Neque Ave','577','L','796252521','Dublin','Sao Tome and Principe','AB','usuário'),('637-791 Fringilla Avenue','104','SP','090194102','Diadema','Equatorial Guinea','ON','usuário'),('300 Ipsum Av.','989','Puebla','303817321','Tehuacán','Congo, the Democratic Republic of the','PIU','usuário'),('R. Arnaldo Martins','613','Vera Cruz','188567935','Guarapuava','Brasil','PR','usuário'),('163-3333 Ac St.','117','NL','972677782','Fortune','Iran','JB','usuário'),('670-2921 Quam. Av.','399','Utah','133809037','Provo','Chile','Sląskie','usuário'),('4440 Ornare St.','637','CAJ','545866303','Jaén','Bonaire, Sint Eustatius and Saba','CV','usuário');
INSERT INTO Endereco (rua,num,bairro,cep,cidade,pais,estado,tipo_end) VALUES ('7823 Euismod Rd.','764','N.','105600500','Heerhugowaard','Suriname','Bolívar','usuário'),('P.O. Box 675, 3456 Ut Av.','960','NA','069179067','Champion','Gambia','Dolnośląskie','usuário'),('5561 Sit St.','036','Michoacán','496617229','Uruapan','Paraguay','Oklahoma','usuário'),('168-4630 Eget, Avenue','222','Atlántico','193237292','Sabanalarga','Turkmenistan','São Paulo','usuário'),('Ap #829-326 Mi. Ave','276','Belgorod Oblast','065744783','Valuyki','Korea, North','Junín','usuário'),('922 Ad Av.','992','Katsina','819502247','Funtua','Saint Barthélemy','OH','usuário'),('9202 Consectetuer, Avenue','535','Victoria','440289318','Bairnsdale','Romania','Clackmannanshire','usuário'),('209-9592 Lacus. St.','637','FATA','661893653','Khyber Agency','Mayotte','Diyarbakır','usuário'),('P.O. Box 737, 9187 Nibh. Avenue','131','A','738846176','San Rafael','Zimbabwe','NI','usuário'),('P.O. Box 334, 6764 Amet Rd.','555','BE','297318240','Berlin','Antarctica','Brussels Hoofdstedelijk Gewest','usuário');
INSERT INTO Endereco (rua,num,bairro,cep,cidade,pais,estado,tipo_end) VALUES ('594 Egestas Rd.','340','Azad Kashmir','403648551','Muzzafarabad','Iceland','São Paulo','usuário'),('Rua General Radinha','719','Samapi','746942368','Teresina','Brasil','PI','usuário'),('Ap #938-646 Egestas Rd.','639','NI','403135586','Taupo','South Sudan','LU','usuário'),('6737 Auctor St.','371','BE','794436704','Berlin','Sierra Leone','Missouri','usuário'),('6544 Pede, St.','566','ANT','566837752','Itagüí','French Southern Territories','Henegouwen','usuário'),('P.O. Box 271, 6008 Mauris Rd.','727','Ver','748671844','Boca del Río','Uzbekistan','Ontario','usuário'),('7774 Quisque Rd.','481','AN','439974238','Rijkevorsel','Tajikistan','LO','usuário'),('8079 Tristique Rd.','563','Coquimbo','954731858','Punitaqui','Northern Mariana Islands','Sokoto','usuário'),('P.O. Box 357, 6445 Morbi Road','455','Idaho','936902632','Nampa','Gibraltar','Uttar Pradesh','usuário'),('1608 Dis Ave','109','North Island','374635034','Auckland','Germany','ON','usuário');
INSERT INTO Endereco (rua,num,bairro,cep,cidade,pais,estado,tipo_end) VALUES ('8400 Turpis Street','474','MA','417932680','Radom','Malawi','A','usuário'),('985-224 Dolor Street','581','Andalucía','799507752','Huelva','Nauru','Jigawa','usuário'),('7459 Quisque St.','311','North Island','218950698','Dannevirke','Qatar','IL','usuário'),('837-3664 Donec Rd.','468','Illinois','172752690','Rockford','Iran','NV','usuário'),('Rua Etevina Vidigal','961','Pium (Distrito Litoral)','122810874','Parnamirim','Brasil','RN','usuário'),('P.O. Box 115, 6534 Mauris, St.','604','Rio de Janeiro','646223113','São Gonçalo','Djibouti','Punjab','usuário'),('668-7051 Praesent Rd.','328','SO','084891508','Sokoto','Zimbabwe','PA','usuário'),('3759 Interdum St.','769','SJ','575394923','Calle Blancos','Western Sahara','VIC','usuário'),('Ap #306-6838 Et Road','216','H','332929019','Ulloa (Barrial)','Liechtenstein','AL','usuário'),('107-9698 Euismod Rd.','662','Jal','960518827','Tonalá','Hungary','San José','usuário');
INSERT INTO Endereco (rua,num,bairro,cep,cidade,pais,estado,tipo_end) VALUES ('500 Laoreet Street','130','British Columbia','874555789','Duncan','Tuvalu','Małopolskie','usuário'),('Ap #398-1364 Ornare St.','602','LOM','616043562','Calco','Papua New Guinea','Antalya','usuário'),('6447 Curabitur St.','005','NSW','290715638','Sydney','Northern Mariana Islands','Sverdlovsk Oblast','usuário'),('5939 Ipsum Ave','838','Ank','284802676','Polatlı','Bahrain','North Chungcheong','usuário'),('Ap #359-3398 Tellus Rd.','032','A','683043012','Alajuela','Namibia','Adana','usuário'),('7584 Aliquam Rd.','424','MA','748122276','Alcalá de Henares','Iran','Vienna','usuário'),('Ap #695-791 Parturient Ave','096','Antioquia','080418907','Apartadó','Virgin Islands, British','Cajamarca','usuário'),('Rua Salgado Filho','794','Parque Florido','246876398','Gravataí','Brasil','RS','usuário'),('P.O. Box 664, 4897 Magna. Rd.','954','Queensland','075286995','Cairns','Lithuania','Imo','usuário'),('301-3685 Ornare, St.','479','Ov','402582877','Zwolle','Bonaire, Sint Eustatius and Saba','Ov','usuário');
---- De Eventos
INSERT INTO Endereco (rua,num,bairro,cep,cidade,pais,estado,tipo_end) VALUES ('Ap #905-7398 Augue St.','570','Gl','802478437','Hattem','Netherlands','Sicilia','evento'),('Ap #450-4224 Vestibulum Avenue','785','Wie','641051220','Vienna','Bahamas','Azad Kashmir','evento'),('Ap #390-8678 Donec Road','792','BE','540479268','Berlin','Côte DIvoire (Ivory Coast)','Bahia','evento'),('1412 Non, Av.','920','Zuid Holland','170506690','Alphen aan den Rijn','United Kingdom (Great Britain)','SL','evento'),('P.O. Box 232, 6106 Malesuada. St.','960','LX','431669563','Saint-Vincent','Niue','Veracruz','evento'),('Ap #105-1933 Ipsum Street','716','Lazio','265374788','Mazzano Romano','Ghana','Metropolitana de Santiago','evento'),('P.O. Box 985, 3441 Nec St.','837','Gye','484723055','Hanam','Kazakhstan','BO','evento'),('Ap #121-1115 Orci St.','109','RM','844263886','Macul','Greenland','DF','evento'),('178-8117 Enim, St.','653','HI','618890584','Kailua','Cambodia','BC','evento'),('P.O. Box 665, 6498 Massa. Av.','717','UP','049146752','Pilibhit','Christmas Island','Mississippi','evento');
INSERT INTO Endereco (rua,num,bairro,cep,cidade,pais,estado,tipo_end) VALUES ('P.O. Box 106, 9169 Phasellus Av.','474','JT','977271244','Semarang','Uruguay','Jeo','evento'),('P.O. Box 683, 3797 Nibh Rd.','442','East Java','988024953','Probolinggo','Fiji','Campania','evento'),('P.O. Box 873, 4672 Gravida Road','432','Ontario','356395070','Midlands','Indonesia','IL','evento'),('Ap #438-785 Fusce St.','095','Catalunya','862860752','Barcelona','Niue','Wie','evento'),('8777 Metus Road','769','Belgorod Oblast','053975736','Valuyki','Georgia','A','evento'),('P.O. Box 105, 5685 Nec Ave','449','BC','370475914','Stewart','Antigua and Barbuda','ANT','evento'),('927-1211 Eu, Rd.','577','Diyarbakır','871896379','Bismil','Liechtenstein','Andalucía','evento'),('P.O. Box 745, 8828 Egestas. Av.','640','Wie','303358830','Vienna','Cuba','Minas Gerais','evento'),('P.O. Box 490, 6500 Vitae Street','524','Munster','963293268','Cork','Cameroon','North Gyeongsang','evento'),('P.O. Box 880, 2603 Mauris Rd.','648','WM','995383014','Ełk','Barbados','ON','evento');

-- Inserindo Usuários (100)
INSERT INTO Usuario (cpf,nome,email,senha,idEnderecoUsuario) VALUES ('32527297263','Xanthus Chandler','a@Maurisvel.org','VFR15DDH9OB',55),('74022244118','Burton Banks','parturient.montes@aliquetmolestietellus.co.uk','JNX04RIZ0JW',37),('35122271528','Yuli Maynard','Quisque@nisiCum.org','CFS13FGC7YI',45),('85979441709','Tucker Mann','Etiam.gravida@risusa.edu','WNV07CAQ3XS',3),('58172314505','Jamalia Ross','tellus.justo@id.com','IDI72LDO9QM',20),('24480096632','Sara Galloway','ut@arcuSed.co.uk','NXT79YVC8TN',69),('82410801877','Cadman Hogan','arcu@gravidanunc.ca','UGZ63PNQ0DC',19),('43161221394','Allistair Nunez','vulputate.eu@interdumlibero.org','VTK22WFN5HD',2),('08504542643','Mannix Trevino','neque.Nullam@seddictumeleifend.com','KCE02NOZ6RQ',80),('31979840492','Mason Chaney','vehicula.et@vehicularisusNulla.ca','HWK69OTD7IA',1);
INSERT INTO Usuario (cpf,nome,email,senha,idEnderecoUsuario) VALUES ('01447619278','Riley Spencer','nec@Aliquamornare.com','FZI40DJI6II',61),('45546520572','Ignacia Anderson','odio.vel@pretiumetrutrum.ca','SBU78OLY3LL',10),('05167853477','Leandra Yates','magna.Ut.tincidunt@diamloremauctor.edu','FXL88HMF9HQ',14),('61968181619','Jessica Roberts','tellus.eu@Nuncuterat.org','JDZ78YFI5UA',35),('02818949032','Whilemina Murphy','Ut.semper@cursus.ca','BKF58ZOF6EG',59),('20487318551','Chloe Trujillo','mollis@Maecenasliberoest.ca','CNE24GZE0JZ',68),('99257394774','Chandler Weeks','lectus.quis@fermentum.ca','JRF94MQQ4GP',21),('55326979713','Hall Sullivan','a@risus.edu','XFM87QDM6RN',64),('08477325411','Angelica Kinney','risus.odio@loremDonecelementum.net','QFA46AFX4VZ',75),('01068952415','Sarah Nixon','cursus.et@condimentumegetvolutpat.org','SJE15HLO4NE',22);
INSERT INTO Usuario (cpf,nome,email,senha,idEnderecoUsuario) VALUES ('94202976580','Francis Preston','Aliquam@gravida.com','OOI18DHN2CH',39),('44196959982','Vaughan Farmer','et@diamProin.ca','EVU68GSG7LH',23),('74161730864','Gannon Marshall','nascetur.ridiculus.mus@neque.net','DBA72RNE4UJ',14),('96479194268','Perry Pate','Quisque.nonummy@ametmassa.ca','PZU92NIR5YL',33),('44852317595','Driscoll Norman','euismod.in@elitafeugiat.net','MOQ78IEH8QY',43),('93525765673','Candice Witt','Pellentesque@primisinfaucibus.edu','IAP88HRS2HQ',2),('73213401002','Price Cook','elit.erat@risusaultricies.co.uk','WTS16HCG5NA',57),('76362838741','Isabelle Monroe','vestibulum.massa@sagittisNullamvitae.co.uk','OLH47TNQ6WH',17),('47228135326','Leandra Emerson','laoreet@mollisdui.edu','HKM73VZG8AA',30),('14728098640','Kevyn Gutierrez','Pellentesque.habitant@Duis.org','NGO94YSJ7VG',72);
INSERT INTO Usuario (cpf,nome,email,senha,idEnderecoUsuario) VALUES ('88467552080','Fulton Miranda','eros.non@semper.edu','GLV22ASI5BK',10),('39180404370','Idona Skinner','odio@diamProin.net','YJR23BWI5QL',55),('36480591747','Marsden Warren','mattis.ornare.lectus@pedenec.edu','IIK44SYS0NJ',29),('96437665788','Olivia Briggs','ac.eleifend.vitae@enim.net','WGL14UKO9ZC',65),('23678529181','Jena Duke','laoreet.libero@orciluctus.org','GTH32QCI3IS',42),('21402442512','Brody Lancaster','lorem.eget@urna.com','MSY35BLA6NZ',17),('45622501924','Lev Anthony','eu@malesuadaaugueut.net','SOC21XBU4DO',60),('32809686509','Wallace Hutchinson','vitae@etmalesuada.com','WNP77NQC2BU',70),('01687251582','Alexander Kirby','ac@vitaepurusgravida.ca','FEF32LJM1HA',31),('27827151739','Leo Woodard','Donec@Sedpharetra.ca','QZG15XVB1PG',51);
INSERT INTO Usuario (cpf,nome,email,senha,idEnderecoUsuario) VALUES ('72359620793','Megan Whitehead','gravida.nunc.sed@erat.com','SHV02YSQ9JO',45),('62896253379','Sandra Gibbs','nisi.Cum@MaurisnullaInteger.edu','OMU96IGP8BM',23),('15555701741','Gavin Levine','Aliquam.ornare@sedliberoProin.net','KMI89DSX1IC',12),('34827718314','Elliott Phelps','enim@enimNunc.org','YIZ45SNV5LZ',78),('31975256514','Aiko Hansen','lectus.rutrum@risusodioauctor.edu','BWP32SXC5OL',24),('55506755026','Nathaniel Roberts','eu@nonantebibendum.ca','SCC12WSG0GG',15),('32947694477','Michelle Schultz','imperdiet.ullamcorper.Duis@insodaleselit.ca','YTB24TGA8VG',55),('30459787169','Willa Berry','a.sollicitudin@Loremipsumdolor.com','QKJ31YWK3NB',43),('67346346102','Mara Curry','Curabitur@nequeNullam.edu','PNR35QYZ5FR',24),('77686074407','Berk Santos','aptent@arcu.co.uk','JLV11EGP3FB',60);
INSERT INTO Usuario (cpf,nome,email,senha,idEnderecoUsuario) VALUES ('21973033435','Elizabeth Gilbert','lobortis.nisi.nibh@tincidunt.ca','VBE06XXC9MU',48),('11963301946','Audrey Ferrell','lacus@Nullamvitaediam.org','MJN61OTD7XG',23),('40767847094','Ahmed Fitzgerald','posuere.cubilia@ultriciesligulaNullam.ca','PKV73QZN4BT',51),('44267242794','Barry Key','turpis.vitae@atlibero.com','NVW84ERV3EI',1),('00556042258','Vance James','eleifend.egestas@Duiscursusdiam.net','GOF62NCE1CG',51),('98050536275','Conan Fulton','Curabitur.consequat@Sednuncest.org','STG35JDQ3PR',68),('34659181692','Henry Donovan','tellus@IncondimentumDonec.co.uk','VXH42UAJ5CR',69),('77936726952','Hector Doyle','arcu.Aliquam.ultrices@musAeneaneget.org','UGD37RJY6QR',50),('66118284000','Olivia Spencer','euismod.et@Nullafacilisi.co.uk','JEM28JAT3TW',30),('16064461224','Wyatt Hyde','arcu@Sed.com','FOW38IEG7MA',47);
INSERT INTO Usuario (cpf,nome,email,senha,idEnderecoUsuario) VALUES ('33109020269','Orla Stein','pharetra@accumsanlaoreetipsum.net','LKI65MNP2KU',45),('66196219367','Vladimir Ellison','ullamcorper.viverra@sagittis.edu','QQD58IFD4SM',3),('78027387198','Ronan Fitzpatrick','eu.tempor.erat@enimSednulla.co.uk','MJJ43JCK3IP',11),('80520664992','Faith Roberts','in@aliquetPhasellus.co.uk','UZG69BON5PG',57),('37275452184','Anthony Barnes','fermentum@nuncullamcorpereu.net','XHC90OHS4EE',75),('53067916651','Norman Obrien','leo@quis.net','BIN26LEQ8QB',29),('95982841396','Eve Terrell','massa@vel.edu','HXQ37MUC2UX',73),('69858448126','Winifred Mccormick','vitae@malesuadafames.org','XNC83DME1RD',2),('27605252868','Quyn Hebert','urna.nec.luctus@magnaaneque.ca','IDW21AMD2GD',67),('38636154259','Hunter Zamora','Vivamus.nisi@estacfacilisis.net','WVK02TMQ8PT',52);
INSERT INTO Usuario (cpf,nome,email,senha,idEnderecoUsuario) VALUES ('91712766508','Haviva Tanner','et.arcu.imperdiet@variuset.ca','XBO78IDN6NW',45),('91948046599','Winifred Le','elementum.purus.accumsan@dignissimMaecenas.org','PUH70QXK6RC',23),('70869299317','Amir Lane','venenatis@Nullam.co.uk','YXG87BOK9PT',54),('86621011063','Karina Deleon','ipsum.dolor.sit@Etiam.ca','DMZ77YWY8GZ',78),('61165415825','Jeremy Palmer','elit.pede.malesuada@interdum.ca','MRD16RDF1PK',78),('74063531496','Gregory Cochran','augue.malesuada.malesuada@velitCras.net','ZHZ52HXC5DI',43),('52927578083','Cally Allen','in@magnaCrasconvallis.ca','HIT95WBB4LC',62),('00151307497','Angelica Lara','blandit.Nam@risusDuisa.co.uk','LFH66QER1ZV',5),('69712517576','Kaseem Long','vitae.aliquet.nec@molestiesodales.ca','BLX84TOS3NX',45),('68515635020','Clare Foster','quam.a.felis@Namtempordiam.edu','WAP02KMZ0MW',14);
INSERT INTO Usuario (cpf,nome,email,senha,idEnderecoUsuario) VALUES ('36530463471','Cheyenne York','egestas@estNunc.net','KEL39TTY0HG',23),('14891172126','Keane Mccray','bibendum.sed@Suspendisseseddolor.org','AUG76SPQ3HJ',16),('00746089787','Florence Estes','Proin.nisl@nequesed.co.uk','OLV64XIB6SN',24),('45628676449','Philip Molina','sit.amet.ornare@adipiscingelit.ca','DPA54KEY5JY',45),('79727590759','Kendall Landry','lorem.lorem.luctus@erat.net','ZRV04VLH4ZA',73),('29012771813','Zenaida Watkins','Duis.mi@CuraeDonectincidunt.co.uk','NSA38PIF5DY',79),('90876482667','Dara Mccray','malesuada.Integer.id@pharetra.ca','PSD77ZFY8SS',2),('41009419232','Harrison Hernandez','ut@ametconsectetuer.net','BTJ09UCN9YJ',71),('51498342516','Justin Byers','amet@id.net','ZCC17WZI9FI',10),('06663496605','Lyle Waller','dignissim.lacus.Aliquam@Suspendisse.ca','VQJ69BOW7QM',34);
INSERT INTO Usuario (cpf,nome,email,senha,idEnderecoUsuario) VALUES ('55512624575','Dylan Park','Nam.ac@Vivamusnisi.com','WWK08GMJ0FA',22),('55583759618','Jillian Marks','hendrerit.neque.In@tinciduntdui.edu','WYV57IND1UI',49),('56624950475','Elmo Russo','enim.consequat.purus@Aliquam.com','NUI72TOR4UI',14),('10531102743','Shafira Myers','dolor.sit.amet@magnisdis.net','IQB13WNB8CG',78),('87874962060','Rogan Eaton','adipiscing.non.luctus@Intinciduntcongue.edu','XFY59CDA4XR',79),('53331188065','Reagan David','eros.Proin.ultrices@risusMorbimetus.co.uk','XRL97YPD4YA',2),('89407022679','Walker Barber','felis.adipiscing@MorbivehiculaPellentesque.org','QXK57VGL6XN',69),('37564657749','Althea Maxwell','pellentesque.a@elementum.net','LUT57GZY5CN',74),('01594204637','Noel Mclaughlin','nibh.Phasellus@mi.edu','TUZ10ZQT7FX',32),('15986688975','Igor Meyers','quam.elementum.at@ornareegestasligula.edu','QHW39LIN9NE',68);

-- Inserindo Telefones (100)
INSERT INTO Telefone (num_tel,idUsuario) VALUES ('(61) 68043-6277',48),('(52) 52141-4086',48),('(62) 65211-5540',48),('(40) 42444-4446',51),('(31) 38764-3261',27),('(78) 02760-4459',96),('(90) 46683-6422',7),('(75) 47335-5716',68),('(74) 79772-5662',68),('(19) 70904-7123',84);
INSERT INTO Telefone (num_tel,idUsuario) VALUES ('(10) 93685-6031',78),('(15) 30547-9917',21),('(99) 51816-4512',61),('(10) 21808-3059',71),('(03) 22634-3706',12),('(72) 49200-4690',11),('(97) 19389-6646',25),('(89) 97576-5285',4),('(40) 39171-4104',77),('(79) 56811-9712',21);
INSERT INTO Telefone (num_tel,idUsuario) VALUES ('(85) 89544-5544',48),('(65) 55721-4755',61),('(05) 83697-9199',90),('(71) 35531-5485',43),('(15) 54266-6718',73),('(52) 66611-7947',33),('(46) 16896-2069',70),('(68) 68502-5512',80),('(69) 81914-2427',85),('(77) 57400-2865',80);
INSERT INTO Telefone (num_tel,idUsuario) VALUES ('(03) 93296-4420',61),('(13) 13011-8949',58),('(88) 20981-5155',2),('(82) 27128-5710',43),('(19) 26083-5360',61),('(55) 68541-1597',76),('(20) 95580-6366',84),('(51) 46096-9077',86),('(90) 41447-7196',29),('(03) 95377-2256',19);
INSERT INTO Telefone (num_tel,idUsuario) VALUES ('(24) 12420-3490',19),('(84) 37519-7804',7),('(51) 66781-2889',97),('(81) 34763-8893',87),('(17) 35385-5159',43),('(62) 03905-4824',82),('(07) 99859-2201',33),('(78) 14335-1913',51),('(17) 97260-5131',22),('(26) 93094-0156',25);
INSERT INTO Telefone (num_tel,idUsuario) VALUES ('(96) 28667-8472',80),('(51) 40756-9978',71),('(93) 61920-7955',65),('(60) 26258-8516',89),('(31) 76989-5748',16),('(07) 65575-2624',86),('(07) 34607-0714',28),('(86) 21814-3127',29),('(89) 41670-4806',91),('(06) 47143-8471',29);
INSERT INTO Telefone (num_tel,idUsuario) VALUES ('(39) 49722-2500',82),('(60) 65768-5429',14),('(75) 02257-7587',34),('(78) 84913-2384',71),('(91) 48996-1253',7),('(21) 74734-6266',79),('(41) 78397-0569',20),('(33) 32794-6163',47),('(24) 80301-2051',87),('(22) 91155-5753',18);
INSERT INTO Telefone (num_tel,idUsuario) VALUES ('(99) 56893-0977',57),('(06) 96288-1736',86),('(14) 30048-9926',93),('(50) 51705-7336',61),('(30) 65517-2556',12),('(09) 00040-8793',84),('(18) 87244-4511',10),('(07) 74335-3680',8),('(05) 69645-7469',55),('(89) 92743-8290',6);
INSERT INTO Telefone (num_tel,idUsuario) VALUES ('(36) 38100-1729',78),('(13) 88534-2325',28),('(42) 05189-6368',98),('(43) 63795-4409',89),('(66) 49596-9275',19),('(34) 99156-8763',44),('(77) 74305-1172',30),('(73) 43519-6049',54),('(34) 19602-8583',35),('(78) 19834-3790',45);
INSERT INTO Telefone (num_tel,idUsuario) VALUES ('(63) 27005-1730',57),('(24) 10002-6435',38),('(33) 10329-1594',30),('(36) 73543-7961',71),('(17) 10676-5652',63),('(38) 72163-6110',64),('(76) 55540-3667',33),('(41) 39754-3983',35),('(91) 68792-2320',64),('(30) 37882-2726',14);

-- Inserindo Organizadores (10)
INSERT INTO Organizador (compr_ident,compr_end,idUsuario) VALUES ('/home/Jillian/comprovante_identidade.pdf','/home/Colby/comprovante_endereço.pdf',29),('/home/Axel/comprovante_identidade.pdf','/home/Kristen/comprovante_endereço.pdf',52),('/home/Sonya/comprovante_identidade.pdf','/home/Yen/comprovante_endereço.pdf',26),('/home/Omar/comprovante_identidade.pdf','/home/Colin/comprovante_endereço.pdf',4),('/home/Uma/comprovante_identidade.pdf','/home/Hannah/comprovante_endereço.pdf',61),('/home/Jameson/comprovante_identidade.pdf','/home/Gemma/comprovante_endereço.pdf',37),('/home/Neville/comprovante_identidade.pdf','/home/Darryl/comprovante_endereço.pdf',48),('/home/Nasim/comprovante_identidade.pdf','/home/Shea/comprovante_endereço.pdf',70),('/home/Dennis/comprovante_identidade.pdf','/home/Kiara/comprovante_endereço.pdf',51),('/home/Brittany/comprovante_identidade.pdf','/home/Yeo/comprovante_endereço.pdf',30);

-- Inserindo Condutores (20)
INSERT INTO Condutor (tipo_condutor,associacao,idUsuario) VALUES ('Professor','UFRGS',82),('Professor','UFSC',60),('Formando','UFSM',56),('Formando','USP',86),('Professor','UFSC',75),('Palestrante',NULL,89),('Professor','USP',21),('Ator','Grupo Teatral Abelhinha Feliz',32),('Ator','Grupo Teatral Nuvem',72),('Palestrante','UFSM',57);
INSERT INTO Condutor (tipo_condutor,associacao,idUsuario) VALUES ('Ator', NULL,62),('Cantor','Banda Titãs',73),('Ator','Grupo Teatral Palácio',61),('Professor','USP',55),('Professor','UFSM',78),('Professor','UFSC',39),('Cantor','Banda Legião Urbana',49),('Palestrante',NULL,34),('Formando',NULL,38),('Cantor','Banda The Black Eyed Peas',76);

-- Inserindo Participantes (90)
INSERT INTO Participante (idUsuario) VALUES (1),(2),(3),(5),(6),(7),(8),(9),(10);
INSERT INTO Participante (idUsuario) VALUES (11),(12),(13),(14),(15),(16),(18),(19),(20);
INSERT INTO Participante (idUsuario) VALUES (21),(22),(24),(25),(26),(27),(28),(29),(30);
INSERT INTO Participante (idUsuario) VALUES (31),(32),(34),(35),(36),(37),(38),(39),(40);
INSERT INTO Participante (idUsuario) VALUES (41),(42),(43),(44),(45),(46),(47),(49),(50);
INSERT INTO Participante (idUsuario) VALUES (51),(53),(54),(55),(56),(57),(58),(59),(60);
INSERT INTO Participante (idUsuario) VALUES (61),(62),(63),(64),(65),(66),(68),(69),(70);
INSERT INTO Participante (idUsuario) VALUES (71),(73),(74),(75),(76),(77),(78),(79),(80);
INSERT INTO Participante (idUsuario) VALUES (82),(83),(84),(85),(86),(87),(88),(89),(90);
INSERT INTO Participante (idUsuario) VALUES (91),(92),(93),(94),(95),(96),(97),(98),(100);

-- Inserindo Funcionarios (10)
INSERT INTO Funcionario (nome,setor,chefe) VALUES ('Suki Finley','Validação de Documentos','Clark Chan'),('Macey Rivers','Fiscalização','Rogan Monroe'),('Ifeoma Harper','Fiscalização','Brynne Sims'),('Nicholas Garner','Validação de Documentos','Breanna Blackwell'),('Katelyn Tran','Treinamento','Owen Campos'),('Harlan Gilmore','Fiscalização','Dustin Herman'),('Jin Vance','Validação de Documentos','Kessie Woodard'),('Talon Solis','Validação de Documentos','Rajah Middleton'),('Chester Finch','Fiscalização','Regan Mcleod'),('Rashad Cole','Validação de Documentos','Sydnee French');

-- Inserindo Categorias (10)
INSERT INTO Categoria (nome,area) VALUES ('Aniversáio','Criança'),('Formatura','Engenharia de Computação'),('Show','Rock'),('Palestra','Cozinha'),('Tecnologia','Programação'),('Vacinação','COVID-19'),('Saúde','Nutrição'),('Festa','Fantasia'),('Show','Eletrônica'),('Show','Sertanejo');

-- Inserindo Eventos (20)
INSERT INTO Evento (nome,valor,data_hora_realizacao,data_hora_criacao,privacidade,idEnderecoEvento) VALUES ('Festa na Piscina',NULL,'2021-04-02 20:33:42-03','2020-04-13 09:48:55-03','público',81),('Aniversário da Clara','102.41','2020-03-08 08:23:31-03','2020-02-15 02:19:18-03','privado',82),('Show do Titãs','75.32','2020-06-08 23:11:18-03','2020-01-14 19:41:19-03','público',83),('Cozinhando como um mestre','260.83','2021-11-12 18:33:33-03','2020-11-30 07:11:03-03','público',84),('Programando sem limites','244.78','2021-08-09 14:14:05-03','2020-07-01 11:30:47-03','privado',85),('Vacinação Coronavírus 2021',NULL,'2021-09-29 02:37:33-03','2021-01-21 09:24:38-03','privado',86),('Rave na laje',NULL,'2019-11-23 09:41:46-03','2019-01-27 04:49:58-03','privado',87),('Tornando-se vegano','137.33','2021-12-13 06:48:25-03','2020-11-14 21:24:08-03','público',88),('Festa de halloween','89.25','2020-09-16 03:36:37-03','2020-07-03 19:44:22-03','público',89),('Chitãozinho e xororó','145.68','2020-03-09 05:57:05-03','2020-01-04 15:04:07-03','público',90);
INSERT INTO Evento (nome,valor,data_hora_realizacao,data_hora_criacao,privacidade,idEnderecoEvento) VALUES ('Show AC/DC','247.80','2021-01-29 17:45:45-03','2019-01-14 07:10:53','público',91),('Debugando o código',NULL,'2021-04-24 01:54:12-03','2019-02-09 15:16:09','público',92),('Programando sem usar o Stack Overflow','119.16','2020-06-26 06:39:27-03','2019-08-11 21:06:14','privado',93),('Fritando um ovo','130.44','2021-07-25 21:56:38-03','2019-09-29 00:05:40','privado',94),('Criando uma dieta','67.04','2020-06-19 05:13:45-03','2019-06-16 12:54:43','público',95),('Festa à fantasia','290.45','2020-03-03 05:14:12-03','2019-08-04 16:21:46','público',96),('Cozinhando um Ovo','241.72','2021-09-07 12:16:17-03','2018-12-12 18:04:22','público',97),('Formatura João','285.54','2021-01-19 13:20:01-03','2019-03-05 10:15:47','privado',98),('Show Dubdogz','222.95','2019-12-10 17:30:20-03','2019-09-01 15:07:09','público',99),('Show Vintage Culture','22.79','2021-09-05 14:32:38-03','2019-08-12 18:47:48','público',100);

-- Inserindo Serviços (10)
INSERT INTO Servico (nome,empresa,descricao) VALUES ('Som','Leonardo DJ','Serviço de som para animar a festa. Mixagens serão conduzidas pelo Leonardo DJ.'),('Iluminação','Vagalume noturno','Brilhando a sua festa'),('Buffet','Comida dos sonhos','Os melhores pratos da regiãi'),('Infraestrutura','Palco erguido',NULL),('Climatização','Pinguim com frio',NULL),('Fogos','Ilumina Ceu','Fazendo obra de arte no céu'),('Bebida','Nóis trupica mais não cai','Cachaça, Vodka, Wiski e água'),('Enfermaria','SUS','Vamos acabar com essa pandemia!!!'),('Cozinha','Panela Velha',NULL),('Brinquedos','Criança Feliz','Pula pula, piscina de bolinha e muito mais');

-- Inserindo Certificados (20)
INSERT INTO Certificado (carga_hr,tipo_cert,data_hora_emissao,autenticacao_eletr,idUsuario,idEvento) VALUES ('0.31','organização','2021-01-28 21:01:03-03','FRB68OVZ5DQ48Y370600PF17V1J621','37','8'),('0.43','organização','2021-08-02 19:23:38-03','QGD84UHT9NM76W270513YJ24Y0E126','30','9'),('0.97','organização','2021-05-11 13:54:36-03','TCV12MUP3JP96T669925JR16L9M190','52','3'),('0.44','organização','2021-01-22 23:12:50-03','XUC14STR5PY70J931541UP29K5D265','52','5'),('0.74','organização','2020-03-11 12:48:40-03','ZPI93PQA1QS00J909393EV99X6A777','51','6'),('0.97','organização','2020-10-18 10:49:38-03','SZX18TCJ6GN93V610198TX67C9V852','30','10'),('0.22','organização','2021-07-06 14:51:24-03','PJN99PFL3JH82Z285854LD50G6D525','51','1'),('0.92','organização','2020-04-25 02:09:45-03','GJW62KBQ6WX71B382119ZR45Y1X067','29','5'),('0.13','organização','2021-07-02 17:05:49-03','LUH49ZXH7PO42T953896TN58W0B312','48','5'),('0.35','organização','2021-04-16 03:58:36-03','HJP54BVW1GV29U463202ZX59Z6Z018','30','6');
INSERT INTO Certificado (carga_hr,tipo_cert,data_hora_emissao,autenticacao_eletr,idUsuario,idEvento) VALUES ('0.85','condução','2020-07-26 09:49:53-03','GER39ULF1CU38P621953WC00R1I168','49','3'),('0.12','condução','2020-03-22 08:01:58-03','MUQ40KCO0SS07P545126VJ89H5Q713','56','9'),('0.70','condução','2021-02-06 21:31:11-03','XNN42OCB3FS51C280740JO33A2E059','32','1'),('0.27','condução','2020-09-05 06:12:51-03','JMT22GQJ7MT76K189417BX61H0I930','34','2'),('0.32','condução','2019-12-16 13:12:50-03','TXR27TIJ8KR03O610540CH93S7Z327','57','6'),('0.82','condução','2020-05-10 15:32:01-03','TDN96ZQG0XM04O866569QD06N4J786','72','9'),('0.17','condução','2020-09-14 18:06:39-03','WAD00RBU4WB01X009447EP63Y1H328','21','4'),('0.33','condução','2020-11-12 02:16:39-03','QHM84NUZ2UF07L153432IZ62N0G275','60','1'),('0.29','condução','2020-10-26 12:22:50-03','LNZ60FXI3YX00G427703CO40D8Z015','55','9'),('0.69','condução','2020-09-27 11:42:46-03','TBP85ERZ4AG96J619296VI93R0O166','49','9');
INSERT INTO Certificado (carga_hr,tipo_cert,data_hora_emissao,autenticacao_eletr,idUsuario,idEvento) VALUES ('0.55','participação','2020-03-06 07:38:53-03','YFL83JGU1HE94F757556FY91X9R944','56','5'),('0.07','participação','2020-05-17 22:29:08-03','LCS92GWV4VQ38P645432MP57D8Y039','97','6'),('0.44','participação','2020-10-18 15:16:33-03','WUU80UUE7IU59O183113WN48J9P403','97','8'),('0.09','participação','2021-08-07 04:27:10-03','LJK99CSO7FC06A958149RZ64I0D379','83','7'),('0.34','participação','2021-03-11 03:33:46-03','YFR67NLZ6EZ82K464945ZE84S1A384','69','1'),('0.44','participação','2021-11-18 17:45:35-03','VDA11EUQ8YQ68Q694804ZL21W0D475','79','3'),('0.22','participação','2020-07-12 05:59:53-03','DII29OCQ9HH68C222179VE02F0D893','45','2'),('0.38','participação','2020-09-07 09:02:56-03','USF05YOT1BO57S248691CX59Z8Q626','6','5'),('0.18','participação','2020-06-20 07:18:49-03','ANG16KTK5RX41H071666DC90X6Z875','12','5'),('0.06','participação','2021-07-07 18:13:46-03','DIK21COZ8QB39J102538VN06O8K470','73','6');
INSERT INTO Certificado (carga_hr,tipo_cert,data_hora_emissao,autenticacao_eletr,idUsuario,idEvento) VALUES ('0.78','participação','2020-10-23 00:32:29-03','JSM01HHL6TV97N093982TF11V8I147','57','8'),('0.69','participação','2020-12-09 06:56:46-03','ZZI33QPZ9DY35U609561UH24U6V213','62','3'),('0.78','participação','2020-02-26 03:54:20-03','KKW12RLK6KN13J860759QP90D7D233','58','2'),('0.35','participação','2020-10-26 21:54:49-03','XQE62LKE7EV52X097916VJ00A7Q627','11','3'),('0.66','participação','2020-09-19 22:38:31-03','ZUI18ACV0AV04U315860AO20C5D707','100','10'),('0.46','participação','2019-12-21 03:41:33-03','QEG28JRR2OU75G057030JJ79P0M852','20','5'),('0.53','participação','2021-06-19 04:35:43-03','MCT04HAQ5GO56O510863BK57J3H284','6','8'),('0.40','participação','2020-03-07 06:32:03-03','GUR29JDK4BP25F993722RX20A7O593','41','9'),('0.58','participação','2021-11-15 16:51:54-03','PZG78WKO0EY06U371988ND39F3C818','41','4'),('0.17','participação','2021-04-03 20:30:21-03','KRF35EXZ6YW28E368400TJ54R0C664','10','7');
INSERT INTO Certificado (carga_hr,tipo_cert,data_hora_emissao,autenticacao_eletr,idUsuario,idEvento) VALUES ('0.68','participação','2020-09-29 21:08:43-03','SSD67SYM6XP19W253273JM84N7M234','6','9'),('0.96','participação','2021-10-06 22:47:27-03','GAD52RYO6SD37T829623ZF17W9U292','63','10'),('0.82','participação','2020-05-08 23:39:33-03','SJM07FOI8XC58U053985XC48O8Q302','65','7'),('0.57','participação','2021-05-08 15:25:33-03','TEK59TJW4JZ82I165045KC86M9L193','10','10'),('0.80','participação','2021-06-13 14:30:31-03','OFG40NJD8OG03A346215ZH02G6D100','66','6'),('0.51','participação','2020-08-19 10:13:50-03','FVE17KAY0YK12V822019HP70Z4L222','63','5'),('0.94','participação','2019-12-10 15:09:33-03','IJE53TPO4SW37F756101PV59B9E766','27','8'),('0.36','participação','2020-01-21 17:08:46-03','HQX54QZI4XJ18X307891OA86I1D099','92','7'),('0.69','participação','2020-03-09 10:14:39-03','OAM80DLA2EA96Z244604AT78E4Z183','43','8'),('0.06','participação','2021-03-17 00:55:01-03','HLU62IHS2GJ42W386636NY25U8N692','95','7');
INSERT INTO Certificado (carga_hr,tipo_cert,data_hora_emissao,autenticacao_eletr,idUsuario,idEvento) VALUES ('0.05','participação','2021-10-30 04:21:59-03','ITH42IHL0KH46R261028EW27G6Y155','89','6'),('0.43','participação','2020-12-27 01:19:41-03','EWV62NJV5ZO36G155989TL33O4F558','50','1'),('0.51','participação','2020-08-13 20:28:18-03','SXT31RRJ6MO97I689375JE73B0D535','19','10'),('0.21','participação','2021-11-16 06:53:21-03','RDQ37OVQ1CA09W553770LV35G8U412','84','10'),('0.34','participação','2021-03-12 17:27:48-03','BGG69WHI9BE57K803175IC56R3Y118','71','9'),('0.12','participação','2020-08-09 13:37:06-03','XZH04ITB9YN36R567463SM11Q2R247','12','6'),('0.52','participação','2021-08-16 14:04:27-03','ZOG20SAT5YE97C806216UI18L0A419','53','10'),('0.46','participação','2021-04-04 23:31:53-03','FKF12GMB5WD06H848890KO36K8T429','65','1'),('0.83','participação','2020-07-26 04:14:45-03','OSN88PKD8QB40F927918LQ28R5S907','91','9'),('0.47','participação','2020-06-17 17:37:04-03','BWR01FVT9YS91I285973FP95R3V589','44','6');
INSERT INTO Certificado (carga_hr,tipo_cert,data_hora_emissao,autenticacao_eletr,idUsuario,idEvento) VALUES ('0.06','participação','2021-02-07 02:36:18-03','UHY77JOP9TM37E654188MZ26V9Q015','55','10'),('0.12','participação','2021-03-06 07:25:14-03','EBJ65NZU5VP85C839516OU20W4G117','18','1'),('0.76','participação','2021-07-14 18:56:24-03','JUL04YMO6II68K965041KP03Z4V754','14','10'),('0.84','participação','2021-03-03 10:57:28-03','USU02BHF9MG40F910150BB97K2E521','70','2'),('0.52','participação','2021-06-20 20:42:46-03','KYZ05OMC1QN05L437349DD03I8D035','13','6'),('0.48','participação','2020-12-22 05:13:23-03','OEZ40SDD8ZU00I725564KJ31Z5W277','19','2'),('0.37','participação','2021-07-11 16:33:45-03','PHV75NZX0IN74I771867YQ79O7U758','50','8'),('0.32','participação','2021-03-20 15:28:11-03','VWT84CNI9IN17M052991PY94V6L428','15','6'),('0.15','participação','2020-03-21 21:13:29-03','SPT33NRX2RU05P076581HD66H6Y592','95','6'),('0.60','participação','2020-03-14 05:23:49-03','BDD48SLC5PA09T598891XT88K8P143','47','7');
INSERT INTO Certificado (carga_hr,tipo_cert,data_hora_emissao,autenticacao_eletr,idUsuario,idEvento) VALUES ('0.96','participação','2020-04-20 03:30:31-03','ETR73ZOE9TC89N205164ZE57A5K936','69','2'),('0.31','participação','2019-11-28 18:39:26-03','BJW64LXV5MZ77E425417OX77W4A194','42','3'),('0.18','participação','2020-07-05 01:39:34-03','WNF48YUF2WS67G113111LZ57U2J444','66','9'),('0.11','participação','2020-11-20 21:10:15-03','LMD87HQY5SN88B289678XT49W6X241','2','5'),('0.30','participação','2020-08-15 05:15:09-03','TZH34TFT3DJ58C616770VE79E3Q578','7','3'),('0.19','participação','2021-10-17 01:15:14-03','SKE43JAY2IH12W621822LP98A8O163','91','9'),('0.92','participação','2020-07-02 10:31:54-03','KDY63JBR7UN52M531391GF34B7J067','13','1'),('0.54','participação','2020-02-24 23:10:52-03','YSK50URS3VK66T468510BK89F4Y515','56','7'),('0.47','participação','2021-08-14 00:12:35-03','XKT21WQC1NV04V095978QN64N7S139','90','5'),('0.76','participação','2020-01-12 00:21:48-03','ZDI66TTB3WM11W867325VV16U1S337','26','6');

-- Inserindo Relação de Organização (20)
INSERT INTO Organizacao (idOrganizador,idEvento) VALUES ('51',1),('26',2),('61',3),('52',4),('26',5),('29',6),('37',7),('29',8),('51',9),('29',10);
INSERT INTO Organizacao (idOrganizador,idEvento) VALUES ('51',11),('52',11),('29',11),('37',12),('26',13),('61',14),('70',15),('26',16),('29',17),('61',18),('37',19),('30',20);

-- Inserindo Relação de Condução (30)
INSERT INTO Conducao (idCondutor,idEvento) VALUES ('21',1),('60',2),('73',3),('55',4),('82',5),('78',6),('86',7),('78',8),('38',9),('34',10);
INSERT INTO Conducao (idCondutor,idEvento) VALUES ('34',3),('76',3),('55',3),('89',5),('78',7),('72',6),('73',6),('76',6),('32',6),('82',10);
INSERT INTO Conducao (idCondutor,idEvento) VALUES ('82',11),('38',12),('34',13),('21',14),('60',15),('57',16),('39',17),('82',18),('76',19),('34',20);

-- Inserindo Relação de Inscrição (290)
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('84',4,'pendente'),('10',10,'pago'),('94',9,'pendente'),('94',1,NULL),('40',2,'pago'),('82',9,'pago'),('50',8,'pendente'),('29',10,'pendente'),('84',8,'pendente');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('29',1,NULL),('92',6,NULL),('68',4,'pendente'),('26',4,'pendente'),('59',4,'pago'),('29',7,NULL),('3',8,'pendente'),('46',7,NULL),('65',6,NULL),('80',6,NULL);
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('45',8,'pendente'),('1',8,'pago'),('83',7,NULL),('42',10,'pendente'),('61',1,NULL),('55',5,'pago'),('19',9,'pendente'),('54',6,NULL),('95',8,'pago'),('61',5,'pendente');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('61',2,'pendente'),('86',1,NULL),('56',9,'pago'),('2',8,'pendente'),('51',1,NULL),('46',8,'pendente'),('11',7,NULL),('55',3,'pendente'),('69',9,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('91',6,NULL),('66',7,NULL),('58',9,'pendente'),('12',4,'pendente'),('68',7,NULL),('44',3,'pendente'),('54',2,'pendente'),('63',7,NULL),('95',1,NULL),('34',1,NULL);
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('63',9,'pago'),('64',9,'pendente'),('76',1,NULL),('75',4,'pendente'),('8',8,'pago'),('77',6,NULL),('78',7,NULL),('19',4,'pago'),('44',6,NULL),('49',10,'pendente');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('6',10,'pago'),('37',5,'pendente'),('70',7,NULL),('15',10,'pago'),('3',4,'pago'),('55',7,NULL),('28',8,'pendente'),('90',7,NULL);
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('92',10,'pago'),('65',7,NULL),('74',5,'pago'),('63',10,'pendente'),('12',7,NULL),('21',3,'pendente'),('53',3,'pago'),('76',5,'pago'),('87',6,NULL),('98',9,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('59',9,'pago'),('76',4,'pago'),('43',5,'pago'),('50',6,NULL),('6',9,'pago'),('84',5,'pago'),('90',10,'pendente'),('100',2,'pendente');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('49',6,NULL),('58',8,'pendente'),('74',4,'pago'),('35',2,'pendente'),('56',2,'pago'),('1',6,NULL),('92',4,'pendente'),('96',2,'pendente'),('46',1,NULL),('88',5,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('47',10,'pago'),('12',5,'pago'),('89',5,'pendente'),('92',5,'pendente'),('44',8,'pago'),('84',10,'pago'),('70',10,'pendente'),('20',6,NULL),('74',2,'pendente'),('59',2,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('12',8,'pago'),('80',8,'pago'),('26',8,'pendente'),('41',10,'pendente'),('21',4,'pago'),('62',2,'pago'),('50',3,'pendente'),('40',1,NULL),('29',2,'pendente'),('62',6,NULL);
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('49',7,NULL),('31',2,'pendente'),('7',5,'pendente'),('37',1,NULL),('82',3,'pago'),('76',6,NULL),('63',4,'pendente'),('90',5,'pendente'),('22',8,'pago'),('12',10,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('56',8,'pago'),('47',5,'pendente'),('82',6,NULL),('79',9,'pendente'),('37',3,'pendente'),('36',3,'pago'),('3',7,NULL),('58',6,NULL),('22',10,'pago'),('25',7,NULL);
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('100',8,'pago'),('45',5,'pago'),('66',1,NULL),('14',6,NULL),('21',5,'pago'),('36',7,NULL),('64',5,'pago'),('45',10,'pendente'),('60',6,NULL);
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('20',3,'pendente'),('40',3,'pendente'),('84',7,NULL),('46',2,'pago'),('31',9,'pago'),('10',4,'pendente'),('8',5,'pendente'),('57',8,'pendente'),('32',5,'pago'),('45',1,NULL);
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('98',6,NULL),('20',1,NULL),('16',2,'pendente'),('86',2,'pendente'),('2',4,'pendente'),('1',9,'pendente'),('14',1,NULL),('37',9,'pago'),('56',6,NULL);
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('15',7,NULL),('35',7,NULL),('92',9,'pendente'),('26',3,'pago'),('28',5,'pago'),('12',6,NULL),('53',6,NULL),('16',9,'pendente'),('93',2,'pendente'),('25',6,NULL);
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('50',9,'pendente'),('32',6,NULL),('55',4,'pendente'),('86',3,'pendente'),('32',3,'pago'),('70',8,'pendente'),('40',9,'pago'),('24',8,'pago'),('42',8,'pendente');
-- Inscrição nos eventos de 11 a 20
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('77',20,'pago'),('55',16,'pago'),('27',17,'pendente'),('43',18,'pago'),('1',11,'pago'),('29',17,'pago'),('50',19,'pendente'),('32',13,'pendente'),('3',18,'pendente'),('36',15,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('66',12,NULL),('88',12,NULL),('42',20,'pendente'),('28',12,NULL),('1',17,'pago'),('92',12,NULL),('61',18,'pendente'),('88',14,'pendente'),('71',20,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('35',19,'pago'),('54',15,'pago'),('65',11,'pago'),('38',11,'pago'),('84',16,'pago'),('35',15,'pendente'),('44',12,NULL),('26',18,'pendente'),('70',12,NULL),('26',19,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('66',14,'pendente'),('36',16,'pendente'),('53',18,'pendente'),('31',15,'pago'),('46',17,'pendente'),('9',11,'pago'),('20',20,'pago'),('36',12,NULL),('96',13,'pendente'),('29',12,NULL);
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('37',20,'pago'),('66',20,'pago'),('29',16,'pendente'),('41',20,'pago'),('36',19,'pendente'),('65',12,NULL),('94',17,'pago'),('34',11,'pago'),('49',12,NULL),('88',15,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('55',20,'pendente'),('18',19,'pendente'),('41',11,'pendente'),('40',20,'pendente'),('37',18,'pendente'),('89',20,'pago'),('46',16,'pago'),('77',13,'pendente'),('59',16,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('93',14,'pendente'),('25',14,'pendente'),('96',16,'pago'),('16',19,'pendente'),('100',20,'pago'),('66',19,'pago'),('8',11,'pago'),('59',15,'pago'),('51',14,'pendente');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('100',19,'pago'),('80',17,'pago'),('11',16,'pago'),('45',20,'pago'),('49',16,'pago'),('93',17,'pendente'),('28',19,'pago'),('64',19,'pago'),('22',17,'pendente'),('90',20,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('88',18,'pendente'),('12',18,'pendente'),('42',12,NULL),('46',19,'pendente'),('90',18,'pago'),('8',17,'pendente'),('28',16,'pendente'),('32',17,'pago'),('66',16,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('30',11,'pendente'),('74',14,'pendente'),('73',15,'pago'),('60',13,'pago'),('60',18,'pago'),('95',13,'pago'),('96',12,NULL),('82',11,'pago'),('18',15,'pago'),('12',11,'pago');
-- Dados para testar o NOT EXISTS
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('5',6,NULL),('5',1,NULL),('5',7,NULL),('5',14,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('39',6,NULL),('39',1,NULL),('39',7,NULL),('39',14,'pago');
INSERT INTO Inscricao (idParticipante,idEvento,situacao) VALUES ('13',6,NULL),('13',1,NULL),('13',7,NULL),('13',14,'pago');

-- Inserindo Relação de Interesse (50)
INSERT INTO Interesse (idParticipante,idCategoria) VALUES ('18',3),('87',2),('71',9),('10',8),('73',2),('62',10),('40',8),('91',4),('3',4),('91',1);
INSERT INTO Interesse (idParticipante,idCategoria) VALUES ('9',6),('74',1),('57',10),('66',8),('61',9),('3',9),('37',7),('85',7),('65',9),('28',6);
INSERT INTO Interesse (idParticipante,idCategoria) VALUES ('19',6),('69',5),('86',1),('27',6),('50',1),('78',7),('25',1),('11',7),('92',6),('36',9);
INSERT INTO Interesse (idParticipante,idCategoria) VALUES ('34',3),('11',4),('46',5),('2',9),('16',6),('74',3),('49',5),('32',10),('44',9),('22',10);
INSERT INTO Interesse (idParticipante,idCategoria) VALUES ('55',9),('74',8),('40',7),('64',7),('2',10),('45',1),('54',7),('98',8),('9',10),('74',2);
INSERT INTO Interesse (idParticipante,idCategoria) VALUES ('3',5),('12',1),('68',3),('94',10),('11',9),('41',6),('91',8),('39',1),('15',10),('8',4);
INSERT INTO Interesse (idParticipante,idCategoria) VALUES ('24',5),('82',7),('40',5),('11',10),('97',1),('95',5),('35',6),('70',3),('60',10),('92',1);
INSERT INTO Interesse (idParticipante,idCategoria) VALUES ('96',7),('66',2),('74',5),('26',1),('90',5),('7',1),('77',4),('9',3),('19',3),('46',8);
INSERT INTO Interesse (idParticipante,idCategoria) VALUES ('24',7),('64',10),('41',1),('46',2),('89',5),('21',9),('64',8),('32',3),('38',4),('98',6);

-- Inserindo Relação de Pertence (10)
INSERT INTO Pertence (idCategoria,idEvento) VALUES (5,1),(7,2),(2,3),(3,4),(1,5),(10,6),(9,7),(8,8),(5,9),(1,10);
INSERT INTO Pertence (idCategoria,idEvento) VALUES (3,11),(5,12),(5,13),(4,14),(7,14),(7,15),(8,16),(4,17),(2,18),(9,19),(9,20);

-- Inserindo Relação de Validacao (12)
INSERT INTO Validacao (idFuncionario,idOrganizador,data_hora,aprovado) VALUES (3,37,'2020-08-10 14:05:06-3',FALSE),(1,51,'2021-06-26 17:32:31-3',FALSE),(9,51,'2021-10-22 02:32:50-3',FALSE),(5,61,'2020-07-30 10:33:37-3',TRUE),(4,4,'2021-08-12 19:40:31-3',FALSE),(1,61,'2020-07-19 09:01:44-3',FALSE),(1,30,'2020-12-06 03:54:37-3',FALSE),(8,26,'2020-05-03 10:11:52-3',TRUE),(9,4,'2020-01-21 14:06:41-3',TRUE),(9,51,'2021-06-07 08:00:12-3',TRUE),(1,37,'2020-10-10 14:05:06-3',TRUE),(2,30,'2020-12-20 03:54:37-3',TRUE);

-- Inserindo Relação de Contratacao (10)
INSERT INTO Contratacao (idEvento,idServico,data_hora_contratacao) VALUES ('10','5','2020-03-15 07:09:17-3'),('4','6','2021-10-25 10:25:52-3'),('6','6','2021-10-24 01:38:18-3'),('3','9','2020-03-06 20:05:49-3'),('1','7','2020-08-25 15:57:21-3'),('2','2','2021-07-12 01:39:53-3'),('5','5','2020-02-16 17:34:29-3'),('9','5','2020-10-09 07:44:54-3');
INSERT INTO Contratacao (idEvento,idServico,data_hora_contratacao) VALUES (16,7,'2020-02-25 01:11:26-03'),(19,2,'2021-07-05 09:29:56-03'),(12,6,'2021-02-16 06:53:09-03'),(13,2,'2021-08-27 21:40:30-03'),(15,8,'2021-07-11 06:21:18-03'),(12,5,'2021-01-02 04:02:39-03'),(11,9,'2020-05-17 23:58:44-03'),(18,4,'2021-08-26 04:20:16-03');

SELECT * FROM Telefone;
SELECT * FROM Usuario;
SELECT * FROM Endereco;
SELECT * FROM Participante;
SELECT * FROM Organizador;
SELECT * FROM Condutor;
SELECT * FROM Funcionario;
SELECT * FROM Categoria;
SELECT * FROM Evento;
SELECT * FROM Servico;
SELECT * FROM Certificado;
SELECT * FROM Organizacao;
SELECT * FROM Conducao;
SELECT * FROM Inscricao;
SELECT * FROM Interesse;
SELECT * FROM Pertence;
SELECT * FROM Validacao;
SELECT * FROM Contratacao;

select * 
from participante natural join
	 usuario natural join 
	 endereco;
	 
select *
from endereco
where pais = 'Brasil';


select *
from usuario
order by idEnderecoUsuario;

select *
from evento;

select *
from categoria;

select *
from inscricao;

-- ************* Visão *************

-- HISTORINHA:	Haverá uma empresa Brasileira tercerizada responsável por fazer a cobrança de usuários brasileiros inadimplentes, para isso a empresa deverá ter acesso
-- 				a uma tabela com algumas informações, como id do participante, nome do participante, telefone e email para contato, país do participante, nome do evento, 
-- 				número de inscrição, valor do evento e a situação

-- BUSCA:	Participantes Brasileiros que se increveram em eventos pagos e estão com a situação pendente

CREATE VIEW ParticipantesBrasileirosInadimplentes
AS	select idparticipante, usuario.nome as Nome_Usuario, num_tel, email, pais, evento.nome as Nome_Evento, num_inscricao, valor, situacao
	from participante join inscricao on (idUsuario = idParticipante) natural join evento join 
		 usuario using(idUsuario) join 
		 endereco on(idEnderecoUsuario = idEndereco) natural join
		 telefone
	where pais = 'Brasil' and situacao = 'pendente';

-- drop view ParticipantesBrasileirosInadimplentes




-- ************* Group By *************

-- BUSCA:	Nome de usuário e em quantas incrições cada um tem
select nome, idUsuario, count (num_inscricao)
from participante natural join usuario join inscricao on(idUsuario = idParticipante)
group by nome, idUsuario
order by nome;


-- BUSCA:	Quantidade de participantes que tem interesse em cada categoria
select nome, count (distinct idParticipante)
from categoria natural join interesse natural join inscricao
group by nome;


-- HISTORINHA:	Existem algums particiantes que não se inscrevem em nenhum evento, a equipe de satisfação gostaria de descobrir o motivo.
--				Para isso a equipe de satisfação deve descobrir quais as categorias que participantes que não se inscreveram em nada tem interesse.
-- 				Tambem deve ser mostrado a quantia de participantes que tem interesse em cada categoria, para que a equipe saiba que tipo de evento eles precisam
-- 				priorizar no momento de incentivar a criação de novos eventos.
-- BUSCA:	Categorias e quantidade de participantes (que não se inscreveram em nada) que tem interesse
select nome as categoria, count (idParticipante) as qtd_interesse_participantes_nao_inscritos
from categoria natural join interesse
where idParticipante IN (select idUsuario
						from participante
						where idUsuario NOT IN (select idParticipante
													 from participante join inscricao on(idUsuario = idParticipante)))
group by nome
order by nome;


-- ************* Group By com Having *************
-- HISTORINHA:	A Equipe de Mimos da Plataforma gostaria de enviar brindes para Participantes que moram em um mesmo endereço que outros participantes da plataforma 
-- 				(A principio uma familia). Para que uma familia possa receber o brinde deve existir mais de 1 morador que tem cadastro como participante.
-- 				Também é necessário que de todas as pessoas que moram na casa, existam mais de 4 inscrições em eventos
-- BUSCA:	Mostrar o id do endereço onde moram mais de 1 participante cadastrado na plaforma E que somando as inscrições de todos exitam mais de 4 inscrições em eventos
--			Para cada id de endereço, mostrar a quantidade de participantes naquele endereço e o número total de inscrições das pessoas daquele endereço
select idEndereco, count(distinct idUsuario) as participantes_mesmo_endereco, count(distinct num_inscricao) as numero_de_inscricoes
from participante natural join usuario join endereco on(idEnderecoUsuario = idEndereco) left join inscricao on (idparticipante = idUsuario)
group by idEndereco
having count(distinct idUsuario) > 1 and count(distinct num_inscricao) > 4;




-- ************* Subconsulta *************

-- Participantes que NÃO se increveram em eventos
select *
from participante natural join usuario
where idUsuario NOT IN (select idParticipante
			  				 from participante join inscricao on(idUsuario = idParticipante));

-- Mostrar o id e nome dos organizadores que também são participantes (em um mesmo evento ou em eventos distintos)
select idUsuario, nome
from organizador natural join usuario
where idUsuario IN (select idUsuario
					from participante);
					
-- Eventos que NÃO contrataram algum serviço
select *
from evento
where idEvento NOT IN (select idEvento 
					   from evento natural join contratacao left join servico using(idServico));



-- ************* Consultas Not Exist *************
-- Exibir as informações dos Participantes que se increveram em TODOS os eventos que o participante com id 5 se inscreveu
select *
from usuario
where idUsuario IN (
					select idUsuario
					from participante PARTIC
					where idUsuario <> '5' and
						NOT EXISTS(select *
								   from inscricao
								   where idParticipante = '5' and
										idEvento NOT IN (
														 select distinct idEvento
														 from inscricao
														 where idParticipante = PARTIC.idUsuario
														 )
								  )
					);




-- ************* Consulta usando a Visão *************
-- Exibir os certificados que o participantes brasileiros inadimplentes possuem
-- Mostrar o nome do participante, o nome do evento que gerou o certificado, a data e hora de emissão do certificado e a autenticação eletrõnica
select distinct nome_usuario,  evento.nome as nome_evento, data_hora_emissao, autenticacao_eletr
from ParticipantesBrasileirosInadimplentes join certificado on (idParticipante = idUsuario) join evento using(idEvento);




-- ************* Consultas livres *************

-- Exibir a quantidade de participantes, condutores e organizadores de cada evento
select nome, count(distinct idParticipante) as num_participantes, count(distinct idCondutor) as num_condutores, count(distinct idOrganizador) as num_organizadores
from evento natural join inscricao natural join organizacao natural join conducao
group by nome
order by nome;


-- Exibir as categorias de eventos e o total de certificado que elas emitiram
select categoria.nome as nome_categoria, count (distinct idCertificado) as certificados_emitidos_categoria
from certificado natural join 
	 evento natural join 
	 pertence join 
	 categoria using(idCategoria)
group by categoria.nome;


-- Exibir as categorias de eventos que tiveram mais participantes
select categoria.nome as nome_categoria, count (distinct idParticipante) as participantes_inscritos_em_categorias
from inscricao natural join 
	 evento natural join 
	 pertence join 
	 categoria using(idCategoria)
group by categoria.nome;

-- Eventos que contrataram algum serviço
select * 
from evento natural join contratacao left join servico using(idServico);

-- Exibir nome dos organizadores que estão aprovados a criar eventos no sistema. Exibir também o funcionário que aprovou o organizador
select distinct usuario.nome as organizador, funcionario.nome as funcionario, aprovado
from organizador join validacao on(idUsuario = idOrganizador) join funcionario using(idFuncionario) join usuario using(idUsuario)
where aprovado is true;
