/**
    Projeto:                    Credentium
    Autor:                      José Quintinno
    Demanda:                    CREDENTIUM20250919151817DTB
    Objetivo:                   Modelar entidades da funcionalidade de gestão de credenciais
**/

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

drop table if exists tb_categoria_autenticacao cascade;
drop table if exists tb_instituicao cascade;
drop table if exists tb_autenticacao cascade;

create table if not exists tb_categoria_autenticacao (
    code bigserial not null,
    code_public uuid not null default uuid_generate_v4(),
    descricao varchar (255) not null,
    data_criacao timestamp not null default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    usuario_operacao varchar (255) null,
    active boolean not null default true,
    constraint pk_categoria_autenticacao primary key (code),
    constraint un_categoria_autenticacao unique (descricao)
);

insert into 
    tb_categoria_autenticacao (descricao) 
values 
    ('CREDENCIAL'), ('WIFI'), ('BANCO_DADOS'), ('Cartão Bancário'), ('SSH'), ('TOKEN');

create table if not exists tb_instituicao (
    code bigserial not null,
    code_public uuid not null default uuid_generate_v4(),
    descricao varchar (255) not null,
    data_criacao timestamp not null default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    usuario_operacao varchar (255) null,
    active boolean not null default true,
    constraint pk_instituicao primary key (code),
    constraint un_instituicao unique (descricao)
);

insert into 
    tb_instituicao (descricao) 
values 
    ('Microsoft'), ('Google'), ('Github'), ('Deezer'), ('Oracle'), ('Amazon Web Service (AWS)');

create table if not exists tb_autenticacao (
    code bigserial not null,
    code_public uuid not null default uuid_generate_v4(),
    id_categoria_autenticacao serial not null,
    id_instituicao serial not null,
    usuario varchar (255) not null,
    senha varchar (255) not null,
    descricao varchar (255) not null,
    url text not null,
    data_criacao timestamp not null default now(),
    data_edicao timestamp null,
    data_delecao timestamp null,
    usuario_operacao varchar (255) null,
    active boolean not null default true,
    constraint pk_autenticacao primary key (code),
    constraint fk_categoria_autenticacao foreign key (id_categoria_autenticacao) references tb_categoria_autenticacao (code),
    constraint fk_instituicao foreign key (id_instituicao) references tb_instituicao (code),
    constraint un_autenticacao unique (id_instituicao, usuario)
);

insert into tb_autenticacao (id_categoria_autenticacao, id_instituicao, descricao, usuario, senha, url) values (
    1, 
    1, 
    'Conta Microsoft', 
    'josequintino@hotmail.com.br', 
    'senha-segura', 
    'https://accounts.google.com/v3/signin/identifier?continue=https%3A%2F%2Faccounts.google.com%2F&followup=https%3A%2F%2Faccounts.google.com%2F&ifkv=AfYwgwW_rgYGfJFIp3MVliqT4-_kzOQg57u1kozsS3wnRrg494SeOANgu_jBp1Sl1P-JWx9Fe6ADHw&passive=1209600&flowName=GlifWebSignIn&flowEntry=ServiceLogin&dsh=S-402098856%3A1758309429733291'
);

select * from tb_autenticacao;

/*
Regras

- Os campos: Instituição, Usuário devem ser únicos
- O campo senha deve ser alterado, preferencialmente, a cada três meses (mandar notificação de senha a ser alterada)
- Manter histórico de senhas para não permitir senha já usadas anteriormente
*/