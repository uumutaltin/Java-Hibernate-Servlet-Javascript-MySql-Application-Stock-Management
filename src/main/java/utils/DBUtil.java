package utils;

import entities.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Collections;
import java.util.List;

public class DBUtil {

    SessionFactory sf = HibernateUtil.getSessionFactory();

    // total product purchase
    public int totalProductPurchase(){
        int total = 0;
        List<Product> ls = allProduct();
        for(Product item : ls){
            total = total + (item.getPro_purchase_price());
        }
        return total;
    }
    // total product sale
    public int totalProductSale(){
        int total = 0;
        List<Product> ls = allProduct();
        for (Product item : ls){
            total = total + (item.getPro_sale_price());
        }
        return total;
    }
    public List<Product> lastFiveProduct(){
        Session sesi = sf.openSession();
        List<Product> ls = sesi.createQuery("from Product ")
                .setMaxResults(5)
                .getResultList();

        Collections.reverse(ls);
        sesi.close();
        return ls;
    }




    // total product amount
    public int totalProduct(){
        int total = 0;
        List<Product> ls = allProduct();
        for(Product item : ls ){
            total = total + (item.getPro_amount());
        }
        return total;

    }



    // all cash in
    public int allCashIn(){
        int total = 0;
        List<Receipt> ls = allReceipt();
        for(Receipt item : ls){
            total = total + (item.getReceipt_total());
        }
        return total;
    }

    public int allCashOut(){
        int total = 0;
        List<PayOut> ls = allPayOut();
        for(PayOut item : ls){
            total = total + (item.getPayOutTotal());
        }
        return total;
    }

    public List<PayOut> allPayOut(){
        Session sesi = sf.openSession();
        List<PayOut> ls = sesi.createQuery("from PayOut").getResultList();
        sesi.close();
        return ls;
    }



    // admin login
    public int login(String email, String password, String remember, HttpServletRequest req, HttpServletResponse resp) {

        Session sesi = sf.openSession();
        List<Admin> ls = null;
        try {
            String sql = "from Admin where email=?1 and password=?2";
            ls = sesi
                    .createQuery(sql)
                    .setParameter(1, email)
                    .setParameter(2,Util.MD5(password))
                    .getResultList();

            if(ls.size() !=0){
                int uid = ls.get(0).getAid();
                String name = ls.get(0).getName();

                req.getSession().setAttribute("uid", uid);
                req.getSession().setAttribute("name", name);

                if ( remember != null && remember.equals("on")) {
                    name = name.replaceAll(" ", "_");
                    String val = uid+"_"+name;
                    Cookie cookie = new Cookie("admin", val);
                    cookie.setMaxAge( 60*60 );
                    resp.addCookie(cookie);
                }
            }
        } catch (Exception e) {
            System.err.println("Login Error : " + e);
        } finally {
            sesi.close();
        }
        return ls.size();
    }






    //All Receipts
    public List<Receipt> allReceipt() {
        Session sesi = sf.openSession();
        List<Receipt> ls = sesi.createQuery("from Receipt").getResultList();
        sesi.close();
        return ls;
    }



    // All BoxActions
    public List<BoxAction> allBoxAction(){
        Session sesi = sf.openSession();
        List<BoxAction> ls = sesi.createQuery("from BoxAction ").getResultList();
        sesi.close();
        return ls;
    }


    // All Customer
    public List<Customer> allCustomer(){
        Session sesi = sf.openSession();
        List<Customer> ls = sesi.createQuery("from Customer ").getResultList();
        sesi.close();
        return ls;
    }
    // All Product
    public List<Product> allProduct(){
        Session sesi = sf.openSession();
        List<Product> ls = sesi.createQuery("from Product ").getResultList();
        sesi.close();
        return ls;
    }

    // single Customer
    public Customer singleCustomer(int cid){
        Customer cus = new Customer();
        try{
            Session sesi = sf.openSession();
            cus = sesi.find(Customer.class,cid);
            sesi.close();
        }catch (Exception ex){
            System.err.println("singleCustomer Error : " + ex);
        }
        return cus;
    }
    // single receipt
    public Receipt singleReceipt(int rid){
        Receipt r = new Receipt();
        try {
            Session sesi = sf.openSession();
            r = sesi.find(Receipt.class,rid);
            sesi.close();
        }catch (Exception ex){
            System.err.println("singleReceipt Error : " + ex);
        }
        return r;

    }

    // single Product
    public Product singleProduct(int pid){
        Product pro = new Product();
        try {
            Session sesi = sf.openSession();
            pro = sesi.find(Product.class,pid);
            sesi.close();
        }catch (Exception ex){
            System.err.println("singleProduct Error : " + ex);
        }
        return pro;
    }

    //add product to list
    public void addProduct(Product pro,int box_id){
        Session sesi = sf.openSession();
        Transaction tr = sesi.beginTransaction();

        int pid = (int) sesi.save(pro);
        String sql = "insert into boxaction_product values(?,?)";
        int status = sesi
                .createNativeQuery(sql)
                .setParameter(1,box_id)
                .setParameter(2,pid)
                .executeUpdate();

        tr.commit();
        sesi.close();
        System.out.println("status : " + status);

    }

    // customerSearch procedure
    public List<Customer> customerSearch(String search){
        Session sesi = sf.openSession();
        List<Customer> customerSearch = sesi.createSQLQuery("CALL customerSearch(?)")
                .addEntity(Customer.class)
                .setParameter(1,search)
                .getResultList();
        customerSearch.forEach(itm->{
            System.out.println(itm);
        });
        sesi.close();
        return customerSearch;
    }
    public List<BoxAction> boxActionsList(long receipt){
        Session sesi = sf.openSession();
        return sesi.createQuery("from BoxAction where box_receipt = ?1")
                .setParameter(1,receipt)
                .getResultList();
    }


    // boxOrders procedure
    public List<BoxAction> boxOrders(long receipt){
        Session sesi = sf.openSession();
        List<BoxAction> boxOrders = sesi
                .createSQLQuery("CALL BoxOrders(:receipt)")
                .addEntity(BoxOrders.class)
                .setParameter("receipt",receipt)
                .getResultList();
        return boxOrders;
    }



}
