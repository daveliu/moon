pdf.text "任务周报明细 #{@week.to_date}", :size => 30, :style => :bold


ary = []
@todo_lists.group_by(&:receiver).each do |receiver, lists|
  lists.each do |list|
	   ary << [receiver.try(:login), list.title, list.state]     
	end
end                       

pdf.table ary, :border_style => :grid,
  :widths => { 0 => 300, 1 => 300, 2 => 300}, 
  :row_colors => ["FFFFFF","DDDDDD"],
  :headers => ["Name", "Task", "Status"],
  :align => { 0 => :left, 1 => :right, 2 => :right, 3 => :right }
