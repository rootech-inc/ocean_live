-- SELEct * FROM po_tran where ocean = 0
ALTER table tran_tr ADD
ocean BIT DEFAULT 0


ALTER table invo ADD
ocean BIT DEFAULT 0

ALTER table inv_tran ADD
ocean BIT DEFAULT 0
update inv_tran set ocean = null

ALTER table adj_tran ADD
ocean BIT DEFAULT 0

ALTER table return_tran ADD
ocean BIT DEFAULT 0

ALTER table purch_ret_tran ADD
ocean BIT DEFAULT 0

update tran_tr set ocean = null
update grn_tran set ocean = null
update adj_tran set ocean = null
update inv_tran set ocean = null

select hd.entry_no,hd.grn_date,total_units,item_ref,hd.loc_id from grn_tran tr 
join grn_hd hd on hd.entry_no = tr.entry_no  where tr.ocean is null and hd.posted = 1 and tr.item_ref = ''

select hd.entry_no,hd.entry_date,total_units,item_ref,hd.loc_from,hd.loc_to from tran_tr tr 
join tran_hd hd on hd.entry_no = tr.entry_no  where tr.ocean is null and hd.posted = 1 and tr.item_ref = ''





-- select hd.entry_no,hd.entry_date,tr.total_units,tr.line_no,hd.loc_id,'',tr.item_code from inv_tran tr join inv_hd hd on hd.entry_no = tr.entry_no where ocean is NULL

-- inv
select hd.entry_no,hd.entry_date,tr.total_units,tr.line_no,hd.loc_id,'',tr.item_code,hd.remark from inv_tran tr join inv_hd hd on hd.entry_no = tr.entry_no where ocean is NULL and hd.valid = 1 and hd.posted = 1;

-- gr
select hd.entry_no,hd.grn_date,tr.total_units,tr.line_no,hd.loc_id,'',tr.item_code,hd.remark from grn_tran tr join grn_hd hd on hd.entry_no = tr.entry_no where ocean is NULL and hd.valid = 1 and hd.posted = 1;
-- ad
select hd.entry_no,hd.entry_date,tr.total_units,tr.line_no,hd.loc_id,'',tr.item_code,hd.reason from adj_tran tr join adj_hd hd on hd.entry_no = tr.entry_no where ocean is NULL and hd.valid = 1 and hd.posted = 1;

-- tr
select hd.entry_no,hd.entry_date,tr.total_units,tr.line_no,hd.loc_from,loc_to,tr.item_code,hd.remark from tran_tr tr join tran_hd hd on hd.entry_no = tr.entry_no where ocean is NULL and hd.valid = 1 and hd.posted = 1;

-- sales return srt
select hd.entry_no,hd.entry_date,tr.total_units,tr.line_no,hd.loc_id,'',tr.item_code,hd.remark from return_tran tr join return_hd hd on hd.entry_no = tr.entry_no where ocean is NULL and hd.valid = 1 and hd.posted = 1;

-- purchase return PRT
select hd.entry_no,hd.entry_date,tr.total_units * -1 as 'total_units',tr.line_no,hd.loc_id,'',tr.item_code,hd.remark from purch_ret_tran tr join purch_ret_hd hd on hd.entry_no = tr.entry_no where ocean is NULL and hd.valid = 1 and hd.posted = 1;