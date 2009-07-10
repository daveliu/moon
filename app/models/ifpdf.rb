require 'iconv'
require 'rfpdf/fpdf'
require 'rfpdf/chinese'

include ActionView::Helpers::TextHelper
include ActionView::Helpers::NumberHelper

class IFPDF < FPDF
#        include Redmine::I18n
  attr_accessor :footer_date
  
  def initialize(lang)
    super()
#    set_language_if_valid lang
    extend(PDF_Chinese)
    AddGBFont()
    @font_for_content = 'GB'
    @font_for_footer = 'GB'

#    SetCreator(Redmine::Info.app_name)
    SetFont(@font_for_content)
  end
  
  def SetFontStyle(style, size)
    SetFont(@font_for_content, style, size)
  end
  
  def SetTitle(txt)
    txt = begin
      utf16txt = Iconv.conv('UTF-16BE', 'UTF-8', txt)
      hextxt = "<FEFF"  # FEFF is BOM
      hextxt << utf16txt.unpack("C*").map {|x| sprintf("%02X",x) }.join
      hextxt << ">"
    rescue
      txt
    end || ''
    super(txt)
  end

  def textstring(s)
    # Format a text string
    if s =~ /^</  # This means the string is hex-dumped.
      return s
    else
      return '('+escape(s)+')'
    end
  end
    
  def Cell(w,h=0,txt='',border=0,ln=0,align='',fill=0,link='')
    @ic ||= Iconv.new('gb18030', 'UTF-8')
    # these quotation marks are not correctly rendered in the pdf
    txt = txt.gsub(/[â€œâ€�]/, '"') if txt
    txt = begin
      # 0x5c char handling
      txtar = txt.split('\\')
      txtar << '' if txt[-1] == ?\\
      txtar.collect {|x| @ic.iconv(x)}.join('\\').gsub(/\\/, "\\\\\\\\")
    rescue
      txt
    end || ''
    super w,h,txt,border,ln,align,fill,link
  end
  
  def Footer
    SetFont(@font_for_footer, 'I', 8)
    SetY(-15)
    SetX(15)
    Cell(0, 5, @footer_date, 0, 0, 'L')
    SetY(-15)
    SetX(-30)
    Cell(0, 5, PageNo().to_s + '/{nb}', 0, 0, 'C')
  end
  
  def self.heros_pdf
    #     pdf = IFPDF.new("zh")  
    #     pdf.SetTitle("发")   
    #     pdf.AddPage
    #     # pdf.AddBig5Font
    #     # pdf.SetFont('Big5','',18)      
    # pdf.Write(5, '我们')
    #     pdf.Output      
    pdf = IFPDF.new("zh")
    pdf.SetTitle("zzz")
    pdf.AliasNbPages
    pdf.footer_date = Date.today.to_s
    pdf.AddPage("L")
    pdf.SetFontStyle('B',12)
    pdf.SetX(15)
    pdf.Cell(70, 20, "zzzz")
    pdf.Ln
    pdf.SetFontStyle('B',9)

    subject_width = 70
    header_heigth = 5

    headers_heigth = header_heigth
    show_weeks = false
    show_days = false

    show_days = true
    headers_heigth = 3*header_heigth

    g_width = 210
    g_height = 120
    t_height = g_height + headers_heigth

    y_start = pdf.GetY

    # Months headers
    month_f = "6" #gantt.date_from
    left = subject_width
    height = header_heigth


    pdf.SetY(y_start)
    pdf.SetX(15)
    pdf.Cell(subject_width+g_width-15, headers_heigth, "", 1)

    # Tasks
    top = headers_heigth + y_start
    pdf.SetFontStyle('B',7)

    pdf.Line(15, top, subject_width+g_width, top)
    pdf.Output
    
  end
end



# Returns a PDF string of a gantt chart
def gantt_to_pdf(gantt, project)
  pdf = IFPDF.new(current_language)
  pdf.SetTitle("#{l(:label_gantt)} #{project}")
  pdf.AliasNbPages
  pdf.footer_date = format_date(Date.today)
  pdf.AddPage("L")
  pdf.SetFontStyle('B',12)
  pdf.SetX(15)
  pdf.Cell(70, 20, project.to_s)
  pdf.Ln
  pdf.SetFontStyle('B',9)
  
  subject_width = 70
  header_heigth = 5
  
  headers_heigth = header_heigth
  show_weeks = false
  show_days = false
  
  if gantt.months < 7
    show_weeks = true
    headers_heigth = 2*header_heigth
    if gantt.months < 3
      show_days = true
      headers_heigth = 3*header_heigth
    end
  end
  
  g_width = 210
  zoom = (g_width) / (gantt.date_to - gantt.date_from + 1)
  g_height = 120
  t_height = g_height + headers_heigth
  
  y_start = pdf.GetY
  
  # Months headers
  month_f = gantt.date_from
  left = subject_width
  height = header_heigth
  gantt.months.times do 
    width = ((month_f >> 1) - month_f) * zoom 
    pdf.SetY(y_start)
    pdf.SetX(left)
    pdf.Cell(width, height, "#{month_f.year}-#{month_f.month}", "LTR", 0, "C")
    left = left + width
    month_f = month_f >> 1
  end  
  
  # Weeks headers
  if show_weeks
    left = subject_width
    height = header_heigth
    if gantt.date_from.cwday == 1
      # gantt.date_from is monday
      week_f = gantt.date_from
    else
      # find next monday after gantt.date_from
      week_f = gantt.date_from + (7 - gantt.date_from.cwday + 1)
      width = (7 - gantt.date_from.cwday + 1) * zoom-1
      pdf.SetY(y_start + header_heigth)
      pdf.SetX(left)
      pdf.Cell(width + 1, height, "", "LTR")
      left = left + width+1
    end
    while week_f <= gantt.date_to
      width = (week_f + 6 <= gantt.date_to) ? 7 * zoom : (gantt.date_to - week_f + 1) * zoom
      pdf.SetY(y_start + header_heigth)
      pdf.SetX(left)
      pdf.Cell(width, height, (width >= 5 ? week_f.cweek.to_s : ""), "LTR", 0, "C")
      left = left + width
      week_f = week_f+7
    end
  end
  
  # Days headers
  if show_days
    left = subject_width
    height = header_heigth
    wday = gantt.date_from.cwday
    pdf.SetFontStyle('B',7)
    (gantt.date_to - gantt.date_from + 1).to_i.times do 
      width = zoom
      pdf.SetY(y_start + 2 * header_heigth)
      pdf.SetX(left)
      pdf.Cell(width, height, day_name(wday).first, "LTR", 0, "C")
      left = left + width
      wday = wday + 1
      wday = 1 if wday > 7
    end
  end
  
  pdf.SetY(y_start)
  pdf.SetX(15)
  pdf.Cell(subject_width+g_width-15, headers_heigth, "", 1)
  
  # Tasks
  top = headers_heigth + y_start
  pdf.SetFontStyle('B',7)
  gantt.events.each do |i|
    pdf.SetY(top)
    pdf.SetX(15)
    
    if i.is_a? Issue
      pdf.Cell(subject_width-15, 5, "#{i.tracker} #{i.id}: #{i.subject}".sub(/^(.{30}[^\s]*\s).*$/, '\1 (...)'), "LR")
    else
      pdf.Cell(subject_width-15, 5, "#{l(:label_version)}: #{i.name}", "LR")
    end
  
    pdf.SetY(top)
    pdf.SetX(subject_width)
    pdf.Cell(g_width, 5, "", "LR")
  
    pdf.SetY(top+1.5)
    
    if i.is_a? Issue
      i_start_date = (i.start_date >= gantt.date_from ? i.start_date : gantt.date_from )
      i_end_date = (i.due_before <= gantt.date_to ? i.due_before : gantt.date_to )
      
      i_done_date = i.start_date + ((i.due_before - i.start_date+1)*i.done_ratio/100).floor
      i_done_date = (i_done_date <= gantt.date_from ? gantt.date_from : i_done_date )
      i_done_date = (i_done_date >= gantt.date_to ? gantt.date_to : i_done_date )
      
      i_late_date = [i_end_date, Date.today].min if i_start_date < Date.today
      
      i_left = ((i_start_date - gantt.date_from)*zoom) 
      i_width = ((i_end_date - i_start_date + 1)*zoom)
      d_width = ((i_done_date - i_start_date)*zoom)
      l_width = ((i_late_date - i_start_date+1)*zoom) if i_late_date
      l_width ||= 0
    
      pdf.SetX(subject_width + i_left)
      pdf.SetFillColor(200,200,200)
      pdf.Cell(i_width, 2, "", 0, 0, "", 1)
    
      if l_width > 0
        pdf.SetY(top+1.5)
        pdf.SetX(subject_width + i_left)
        pdf.SetFillColor(255,100,100)
        pdf.Cell(l_width, 2, "", 0, 0, "", 1)
      end 
      if d_width > 0
        pdf.SetY(top+1.5)
        pdf.SetX(subject_width + i_left)
        pdf.SetFillColor(100,100,255)
        pdf.Cell(d_width, 2, "", 0, 0, "", 1)
      end
      
      pdf.SetY(top+1.5)
      pdf.SetX(subject_width + i_left + i_width)
      pdf.Cell(30, 2, "#{i.status} #{i.done_ratio}%")
    else
      i_left = ((i.start_date - gantt.date_from)*zoom) 
      
      pdf.SetX(subject_width + i_left)
      pdf.SetFillColor(50,200,50)
      pdf.Cell(2, 2, "", 0, 0, "", 1) 
  
      pdf.SetY(top+1.5)
      pdf.SetX(subject_width + i_left + 3)
      pdf.Cell(30, 2, "#{i.name}")
    end
    
    top = top + 5
    pdf.SetDrawColor(200, 200, 200)
    pdf.Line(15, top, subject_width+g_width, top)
    if pdf.GetY() > 180
      pdf.AddPage("L")
      top = 20
      pdf.Line(15, top, subject_width+g_width, top)
    end
    pdf.SetDrawColor(0, 0, 0)
  end
  
  pdf.Line(15, top, subject_width+g_width, top)
  pdf.Output
end
