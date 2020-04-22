create or replace trigger product_b_iud_stmt_restrict
    before insert or update or delete
    on product
begin
    product_pack.restrict_trigger_body();
end product_b_iud_stmt_restrict;
/