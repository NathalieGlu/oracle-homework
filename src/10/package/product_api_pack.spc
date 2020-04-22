create or replace package product_pack is

    -- типы
    type t_product is record (            -- информация о продукте
        name product.p_name%type,
        quantity product.p_quantity%type,
        price product.p_price%type
        );

    -- коды ошибок
    c_error_code_wrong_input_param constant number := -20004;
    c_error_code_quantity_negative constant number := -20005;
    c_error_code_price_negative constant number := -20006;
    c_error_code_change_forbidden constant number := -20007;

    -- описание ошибок
    c_error_msg_wrong_input_param constant varchar2(200 char) := 'Wrong input params';
    c_error_msg_quantity_negative constant varchar2(200 char) := 'Quantity must be positive';
    c_error_msg_price_negative constant varchar2(200 char) := 'Price must be positive';
    c_error_msg_change_forbidden constant varchar2(200 char) := 'Manual change is forbidden';

    -- добавление продукта
    function add_product(
        pi_product t_product    -- продукт
    ) return product.p_id%type;

    -- изменение количества продукта
    procedure change_quantity(
        pi_id in product.p_id%type               -- id продукта
        , pi_quantity in product.p_quantity%type -- количество, на которое уменьшается
    );

    -- изменение цены продукта
    procedure change_price(
        pi_id in product.p_id%type         -- id продукта
        , pi_price in product.p_price%type -- цена продукта
    );

    -- удаление продукта
    procedure delete_product(
        pi_id in product.p_id%type -- id продукта
    );

    -- тело триггера
    procedure restrict_trigger_body;
end;
/
