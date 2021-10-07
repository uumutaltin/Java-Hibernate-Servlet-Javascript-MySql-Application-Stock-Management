package entities;

import lombok.Data;

import javax.persistence.Entity;
import javax.persistence.Id;

@Entity
@Data
public class BoxCustomerProduc {

    @Id
    private int box_id;

    private int box_count;
    private int box_customer_id;
    private int box_product_id;
    private int box_receipt;
    private int cu_id;
    private String cu_address;
    //private int cu_code;
    private String cu_company_title;
    private String cu_email;
    private int cu_mobile;
    private String cu_name;
    private int cu_password;
    private int cu_phone;
    private int cu_status;
    private String cu_surname;
    private String cu_tax_administration;
    private int cu_tax_number;

    private int pro_id;
    private int pro_amount;
    //private int pro_code;
    private String pro_detail;
    private int pro_purchase_price;
    private int pro_sale_price;
    private int pro_tax;
    private String pro_title;
    private int pro_unit;










}
