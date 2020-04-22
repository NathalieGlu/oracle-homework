create or replace package test_product_pack is

    --%suite(Test product_pack)
    --%suitepath(product)

    -- кейсы для процедуры add_product

    --%test(Создание продукта с валидными параметрами API)
    --%aftertest(delete_product)
    procedure add_product_valid_params;

    --%test(Создание продукта с недопустимым количеством приводит к ошибке)
    --%aftertest(delete_product)
    --%throws(-2290)
    procedure add_product_negative_quantity;

    --%test(Создание продукта с недопустимой ценой приводит к ошибке)
    --%aftertest(delete_product)
    --%throws(-2290)
    procedure add_product_negative_price;

    -- кейсы для процедуры change_quantity

    --%test(Изменение количества продукта с валидными параметрами API)
    --%beforetest(create_product)
    --%aftertest(delete_product)
    procedure change_quantity_valid_params;

    --%test(Изменение количества продукта с недопустимым количеством приводит к ошибке)
    --%beforetest(create_product)
    --%aftertest(delete_product)
    --%throws(-20005)
    procedure change_quantity_negative_value;

    --%test(Изменение количества продукта с несуществующим id приводит к ошибке)
    --%beforetest(create_product)
    --%aftertest(delete_product)
    --%throws(-1403)
    procedure change_quantity_non_existing;

    -- кейсы для процедуры change_price

    --%test(Изменение цены продукта с валидными параметрами API)
    --%beforetest(create_product)
    --%aftertest(delete_product)
    procedure change_price_valid_params;

    --%test(Изменение цены продукта с недопустимой ценой приводит к ошибке)
    --%beforetest(create_product)
    --%aftertest(delete_product)
    --%throws(-20006)
    procedure change_price_negative_value;

    --%test(Изменение цены продукта с несуществующим id приводит к ошибке)
    --%beforetest(create_product)
    --%aftertest(delete_product)
    --%throws(-1403)
    procedure change_price_non_existing;

    -- кейсы для процедуры delete_product

    --%test(Удаление продукта с валидными параметрами API)
    --%beforetest(create_product)
    procedure delete_product_valid_params;

    --%test(Удаление продукта с не заданным id приводит к ошибке)
    --%throws(-20004)
    procedure delete_product_with_null;

    -- кейсы на другой функционал

    --%test(Изменение кошелька не через API должно завершаться с ошибкой)
    --%throws(-20007)
    procedure change_product_not_api_error;

    -- вспомогательные процедуры
    procedure create_product;
    procedure delete_product;
end;
/