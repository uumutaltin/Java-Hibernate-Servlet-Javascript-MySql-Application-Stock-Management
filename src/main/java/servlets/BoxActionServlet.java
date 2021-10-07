package servlets;

import com.google.gson.Gson;
import entities.*;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import utils.DBUtil;
import utils.HibernateUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;
import java.util.List;

@WebServlet(name = "boxActionServlet", value = {"/boxAction-get", "/boxAction-post","/boxAction-delete"} )
public class BoxActionServlet extends HttpServlet {

    SessionFactory sf = HibernateUtil.getSessionFactory();
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int cid = Integer.parseInt(req.getParameter("cid"));
        Gson gson = new Gson();
        Session sesi = sf.openSession();
        List<BoxCustomerProduc> ls = sesi.createNativeQuery("SELECT * FROM boxaction as box\n" +
                        "INNER JOIN customer as cu\n" +
                        "on box.box_customer_id = cu.cu_id\n" +
                        "INNER JOIN product as pro\n" +
                        "on pro.pro_id = box.box_product_id\n" +
                        "WHERE box.box_customer_id = ?1 and box.box_status =?2")
                .setParameter(1,cid)
                .setParameter(2,0) // status 0 == still in box not complate
                .addEntity(BoxCustomerProduc.class)
                .getResultList();


        sesi.close();
        String stJson = gson.toJson(ls);
        resp.setContentType("application/json");
        resp.getWriter().write(stJson);




    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int bid = 0;
        Session sesi = sf.openSession();
        Transaction tr = sesi.beginTransaction();
        try{
            String obj = req.getParameter("obj");
            Gson gson = new Gson();
            BoxAction boxAction = gson.fromJson(obj, BoxAction.class);

            DBUtil dbUtil = new DBUtil();
            Product pro = dbUtil.singleProduct( boxAction.getBox_product_id() );
            if(pro.getPro_amount() >= boxAction.getBox_count()) {
                pro.setPro_amount(pro.getPro_amount() - boxAction.getBox_count());
            }
            else {
                pro.setPro_amount(0);
            }
            Customer cus = dbUtil.singleCustomer( boxAction.getBox_customer_id() );
            sesi.update(pro);
            boxAction.setProduct(pro);
            boxAction.setCustomer(cus);
            sesi.save(boxAction);




            tr.commit();
            sesi.close();
            bid = 1;
        }catch (Exception ex){
            System.err.println("Save Or Update Error : " + ex);
        }finally {
            sesi.close();
        }
        resp.setContentType("application/json");
        resp.getWriter().write(""+bid);


    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int return_id = 0;
        Session sesi = sf.openSession();
        Transaction tr = sesi.beginTransaction();
        try {
            int box_id = Integer.parseInt(req.getParameter("box_id"));
            BoxAction boxAction = sesi.load(BoxAction.class,box_id);
            sesi.delete(boxAction);
            tr.commit();
            return_id = boxAction.getBox_id();
        }catch (Exception ex){
            System.err.println("boxDelete Error : " + ex);
        }finally {
            sesi.close();
        }

        resp.setContentType("application/json");
        resp.getWriter().write(""+return_id);

    }
}
