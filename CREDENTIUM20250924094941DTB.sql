/**
    Projeto:                    Credentium
    Autor:                      José Quintinno
    Demanda:                    CREDENTIUM20250924094941DTB
    Objetivo:                   Modelar entidades da funcionalidade de gestão de credenciais
**/

create extension if not exists "uuid-ossp";

drop table if exists tb_categoria_pessoa cascade;
drop table if exists tb_pessoa cascade;
drop table if exists tb_usuario cascade;
drop table if exists tb_autenticacao cascade;
drop table if exists tb_credencial cascade;
drop table if exists tb_banco_dados cascade;

create table if not exists tb_usuario (
	code serial not null,
	code_public uuid not null default uuid_generate_v4(),
	nome varchar (255) not null,
	usuario varchar (255) not null,
	senha varchar (255) not null,
	created_at timestamp not null default now(),
	updated_at timestamp null,
	deleted_at timestamp null,
	active boolean default true,
	constraint pk_usuario primary key (code),
	constraint un_usuario unique (nome, usuario)
);

create table if not exists tb_categoria_pessoa (
	code serial not null,
	code_public uuid not null default uuid_generate_v4(),
	descricao varchar (255) not null,
	sigla varchar (255) not null,
	created_at timestamp not null default now(),
	updated_at timestamp null,
	deleted_at timestamp null,
	active boolean default true,
	constraint pk_categoria_pessoa primary key (code),
	constraint un_categoria_pessoa unique (descricao, sigla)
);

create table if not exists tb_pessoa (
	code serial not null,
	code_public uuid not null default uuid_generate_v4(),
	id_categoria_pessoa bigint not null,
	id_usuario bigint not null,
	nome varchar (255) not null,
	created_at timestamp not null default now(),
	updated_at timestamp null,
	deleted_at timestamp null,
	active boolean default true,
	constraint pk_pessoa primary key (code),
	constraint fk_categoria_pessoa foreign key (id_categoria_pessoa) references tb_categoria_pessoa (code) on delete cascade,
	constraint fk_usuario foreign key (id_usuario) references tb_usuario (code) on delete cascade,
	constraint un_pessoa unique (nome)
);

create table if not exists tb_autenticacao (
	code serial not null,
	code_public uuid not null default uuid_generate_v4(),
	id_pessoa_instituicao bigint not null,
	id_usuario bigint not null,
	created_at timestamp not null default now(),
	updated_at timestamp null,
	deleted_at timestamp null,
	active boolean default true,
	constraint pk_autenticacao primary key (code),
	constraint fk_pessoa_instituicao foreign key (id_pessoa_instituicao) references tb_pessoa (code) on delete cascade,
	constraint fk_usuario foreign key (id_usuario) references tb_usuario (code) on delete cascade
);

create table if not exists tb_credencial (
	code serial not null,
	code_public uuid not null default uuid_generate_v4(),
	id_autenticacao bigint not null,
	usuario varchar (255) not null,
	senha varchar (255) not null,
	token varchar (255) null,
	created_at timestamp not null default now(),
	updated_at timestamp null,
	deleted_at timestamp null,
	active boolean default true,
	constraint pk_credencial primary key (code),
	constraint fk_autenticacao foreign key (id_autenticacao) references tb_autenticacao (code) on delete cascade,
	constraint un_credencial unique (id_autenticacao, usuario)
);

create table if not exists tb_banco_dados (
	code serial not null,
	code_public uuid not null default uuid_generate_v4(),
	id_autenticacao bigint not null,
	hostname varchar (255) not null,
	databasename varchar (255) not null,
	portnumber varchar (255) not null,
	username varchar (255) not null,
	password varchar (255) not null,
	created_at timestamp not null default now(),
	updated_at timestamp null,
	deleted_at timestamp null,
	active boolean default true,
	constraint pk_banco_dados primary key (code),
	constraint fk_autenticacao foreign key (id_autenticacao) references tb_autenticacao (code) on delete cascade,
	constraint un_banco_dados unique (id_autenticacao, hostname, databasename, portnumber, username)
);

/*
	select * from tb_categoria_pessoa;
	select * from tb_pessoa;
	select * from tb_usuario;
	select * from tb_autenticacao;
	select * from tb_credencial;
	select * from tb_banco_dados;
*/

insert into tb_categoria_pessoa (descricao, sigla) values ('Pessoa Física', 'PF');
insert into tb_categoria_pessoa (descricao, sigla) values ('Pessoa Jurídica', 'PJ');

insert into tb_usuario (nome, usuario, senha) values (
	'José Quintinno',
	'email.principal.outlook.com.br', 
	'senha-master'
);

insert into tb_pessoa (id_categoria_pessoa, id_usuario, nome) values (
	(select code from tb_categoria_pessoa where sigla = 'PF'),
	(1),
	'José Quintinno'
);

insert into tb_pessoa (id_categoria_pessoa, id_usuario, nome) values (
	(select code from tb_categoria_pessoa where sigla = 'PJ'),
	(1),
	'Microsoft'
);

insert into tb_autenticacao (id_pessoa_instituicao, id_usuario) values (
	(select code from tb_pessoa where nome = 'Microsoft'),
	(1)
);

insert into tb_credencial (id_autenticacao, usuario, senha) values (
	1,
	'email@hotmail.com.br',
	'senha-segura'
);

insert into tb_credencial (id_autenticacao, usuario, senha) values (
	1,
	'email@outlook.com.br',
	'senha-segura'
);

insert into tb_banco_dados (id_autenticacao, hostname, databasename, portnumber, username, password) values (
	1,
	'localhost', 'db_credential', '5432', 'root', 'senha-segura'
);