create or replace package body product_pack is

    g_is_api boolean := false;

    function add_product(pi_product t_product)
        return product.p_id%type
        is
        v_product_id product.p_id%type;
    begin
        g_is_api := true;
        insert into product(p_id, p_name, p_quantity, p_price)
        values (product_pk.nextval, pi_product.name, pi_product.quantity, pi_product.price)
        returning p_id into v_product_id;
        g_is_api := false;
        return v_product_id;
    exception
        when others then
            g_is_api := false;
            raise;
    end;

    procedure change_quantity(pi_id in product.p_id%type, pi_quantity in product.p_quantity%type)
        is
        v_quantity product.p_quantity%type;
    begin
        if pi_quantity <= 0 then
            raise_application_error(c_error_code_quantity_negative, c_error_msg_quantity_negative);
        end if;

        g_is_api := true;
        select p_quantity
        into v_quantity
        from product
        where pi_id = p_id for update nowait;

        update product set p_quantity = (p_quantity - pi_quantity) where p_id = pi_id;
        g_is_api := false;
    exception
        when others then
            g_is_api := false;
            raise;
    end;

    procedure change_price(pi_id in product.p_id%type, pi_price in product.p_price%type)
        is
        v_price product.p_price%type;
    begin
        if pi_price <= 0 then
            raise_application_error(c_error_code_price_negative, c_error_msg_price_negative);
        end if;

        g_is_api := true;
        select p_price
        into v_price
        from product
        where pi_id = p_id for update nowait;

        update product set p_price = pi_price where p_id = pi_id;
        g_is_api := false;
    exception
        when others then
            g_is_api := false;
            raise;
    end;

    procedure delete_product(pi_id in product.p_id%type)
        is
    begin
        if pi_id is null
            then
              raise_application_error(c_error_code_wrong_input_param,
                                      c_error_msg_wrong_input_param);
        end if;
        g_is_api := true;
        delete from product where p_id = pi_id;
        g_is_api := false;
    exception
        when others then
            g_is_api := false;
            raise;
    end;

    procedure restrict_trigger_body
        is
    begin
        if not (g_is_api or nvl(sys_context('clientcontext', 'force_dml'), 'false') = 'true')
        then
            raise_application_error(
                    c_error_code_change_forbidden
                , c_error_msg_change_forbidden
                );
        end if;
    end;
end;
/
