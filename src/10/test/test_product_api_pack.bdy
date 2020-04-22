create or replace package body test_product_pack is

    g_product_id product.p_id%type;

    function get_non_exists_product return product.p_id%type;

    -- Процедура add_product

    procedure add_product_valid_params
        is
        v_name        product.p_name%type     := 'Продукт А';
        v_quantity    product.p_quantity%type := 20;
        v_price       product.p_price%type    := 1999;
        v_product     product_pack.t_product;
        v_product_row product%rowtype;
    begin
        v_product.name := v_name;
        v_product.quantity := v_quantity;
        v_product.price := v_price;
        g_product_id := product_pack.add_product(v_product);

        select * into v_product_row from product where p_id = g_product_id;
        ut.expect(v_product_row.p_name).to_equal(v_name);
        ut.expect(v_product_row.p_quantity).to_equal(v_quantity);
        ut.expect(v_product_row.p_price).to_equal(v_price);
    end;

    procedure add_product_negative_quantity
        is
        v_name       product.p_name%type     := 'Продукт А';
        v_quantity   product.p_quantity%type := -20;
        v_price      product.p_price%type    := 1999;
        v_product    product_pack.t_product;
        v_product_id product.p_id%type;
    begin
        v_product.name := v_name;
        v_product.quantity := v_quantity;
        v_product.price := v_price;
        v_product_id := product_pack.add_product(v_product);
    end;

    procedure add_product_negative_price
        is
        v_name       product.p_name%type     := 'Продукт А';
        v_quantity   product.p_quantity%type := 20;
        v_price      product.p_price%type    := -1999;
        v_product    product_pack.t_product;
        v_product_id product.p_id%type;
    begin
        v_product.name := v_name;
        v_product.quantity := v_quantity;
        v_product.price := v_price;
        v_product_id := product_pack.add_product(v_product);
    end;

    -- Процедура change_quantity

    procedure change_quantity_valid_params
        is
        v_quantity_to_change product.p_quantity%type := 1;
        v_quantity           product.p_quantity%type;
        v_product_row        product%rowtype;
    begin
        select p_quantity into v_quantity from product where p_id = g_product_id;
        product_pack.change_quantity(g_product_id, v_quantity_to_change);
        select * into v_product_row from product where p_id = g_product_id;

        ut.expect(v_product_row.p_quantity).to_equal(v_quantity - v_quantity_to_change);
    end;

    procedure change_quantity_negative_value
        is
        v_quantity_to_change product.p_quantity%type := -1;
    begin
        product_pack.change_quantity(g_product_id, v_quantity_to_change);
    end;

    procedure change_quantity_non_existing
        is
        v_quantity_to_change product.p_quantity%type := 1;
        v_product_id         product.p_quantity%type;
    begin
        v_product_id := get_non_exists_product();
        product_pack.change_quantity(v_product_id, v_quantity_to_change);
    end;

    -- Процедура change_price
    procedure change_price_valid_params
        is
        v_price_to_change product.p_price%type := 1500;
        v_price           product.p_price%type;
        v_product_row     product%rowtype;
    begin
        select p_price into v_price from product where p_id = g_product_id;
        product_pack.change_price(g_product_id, v_price_to_change);
        select * into v_product_row from product where p_id = g_product_id;

        ut.expect(v_product_row.p_price).to_equal(v_price_to_change);
    end;

    procedure change_price_negative_value
        is
        v_price_to_change product.p_price%type := -1500;
    begin
        product_pack.change_price(g_product_id, v_price_to_change);
    end;

    procedure change_price_non_existing
        is
        v_price_to_change product.p_price%type := 1500;
        v_product_id      product.p_id%type;
    begin
        v_product_id := get_non_exists_product();
        product_pack.change_price(v_product_id, v_price_to_change);
    end;

    -- Процедура delete_product

    procedure delete_product_valid_params
        is
        v_cnt number;
    begin
        product_pack.delete_product(g_product_id);

        select count(1) into v_cnt from product where p_id = g_product_id;
        ut.expect(v_cnt).to_equal(0);
    end;

    procedure delete_product_with_null
        is
    begin
        product_pack.delete_product(null);
    end;

    -- другой функционал

    procedure change_product_not_api_error is
    begin
        delete from product t where p_id = g_product_id;
    end;

    -- вспомогательные процедуры

    -- создание продукта
    procedure create_product is
    begin
        dbms_session.set_context('clientcontext', 'force_dml', 'true');
        insert into product(p_id, p_name, p_quantity, p_price)
        values (product_pk.nextval, 'Продукт', 10, 1500)
        returning p_id into g_product_id;
        dbms_session.set_context('clientcontext', 'force_dml', 'false');
    exception
        when others then
            dbms_session.set_context('clientcontext', 'force_dml', 'false');
    end;

    -- удаление продукта
    procedure delete_product is
    begin
        if g_product_id is null
        then
            return;
        end if;

        dbms_session.set_context('clientcontext', 'force_dml', 'true');
        delete product where p_id = g_product_id;
        g_product_id := null;
        dbms_session.set_context('clientcontext', 'force_dml', 'false');
    exception
        when others then
            g_product_id := null;
            dbms_session.set_context('clientcontext', 'force_dml', 'false');
    end;

    -- получить несуществующий продукт
    function get_non_exists_product return product.p_id%type is
        v_product_id product.p_id%type;
    begin
        v_product_id := round(dbms_random.value(10, 1000), 0);
        return v_product_id;
    end;
end;
/
