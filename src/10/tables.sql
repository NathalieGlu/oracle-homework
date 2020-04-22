--alter session set current_schema = N_GLUSCHENKO;

create table product
(
    p_id       number(5),
    p_name     varchar2(256 char) not null,
    p_quantity number(10, 2)      not null,
    p_price    number(7, 2)       not null,

    constraint product_pk primary key (p_id),
    constraint p_price_ck check ( p_price > 0 ),
    constraint p_quantity_ck check ( p_quantity >= 0 )
);

create sequence product_pk minvalue 1 start with 1 increment by 1;

comment on table product is 'Продукты';
comment on column product.p_id is 'Id продукта';
comment on column product.p_name is 'Наименование продукта';
comment on column product.p_quantity is 'Количество продукта';
comment on column product.p_price is 'Цена продукта';

create or replace package product_pack is

    procedure add_product();
    procedure change_quantity();
    procedure change_price();
    procedure delete_product();
end;