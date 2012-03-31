module GameConfigurationsHelper
  def singleElements ary
      html = ''
      ary.each do |elem|
        case elem["type"]
           when :textBox
            html << "#{content_tag :label, elem["name"]}"
            html << "#{text_field_tag elem["name"],''}"
            html << '<br><br />'
           when :dropDown
            option = ""
            elem["options"].each do |t|
              option << "#{content_tag :option, t.to_s} "
            end  
            html << "#{content_tag :label, elem["name"].to_s}"
            html << "#{select_tag elem["name"].to_s,(option.html_safe) } <br><br />"
            
        end           #end of case statement
      end             #end of each.do       
      return html
  end
  
  def multipleElements ary
      html = ''
      ary.each_index do |i|
        div = ary[i]
        html << "<hr style=\"background-color:#000000;height:2px\"/>"
        html << "<div id=\"#{i.to_s+'d'+1.to_s}\" class=\"#{'c'+i.to_s}\" >"
        html << "<hr/>"
        div.each do |elem|
          case elem["type"]
             when :textBox
               html << "<label>#{elem["name"]}</label>"
               html << "<input type=\"text\" name=\"#{elem["name"]}1\" id=\"#{elem["name"]}1\" />"
               html << '<br><br />'
             when :dropDown
               option = ""
               elem["options"].each do |t|
                 option << "#{content_tag :option, t.to_s} "
               end  
               html << "#{content_tag :label, elem["name"].to_s}"
               html << "#{select_tag elem["name"].to_s+'1',option.html_safe } <br><br />"
          end
        end
        html << "</div><br><br />"
        html << "<input type=\"button\" id=\"b#{i}\" value=\"add\">"
      end
      return html
  end
  
 
  def nonRepeatElement array
    html = ''
    option = ''
    optionForRepeat = ''
    optionForRepeat << "#{content_tag :option, "One Element",:selected => "selected"}"
    optionForRepeat << "#{content_tag :option, "Multiple Elements"}"
    optionForRepeat << "#{content_tag :option, "comma Seperated Multiple"}"
    array.each_index do |t|
      div  = array[t]
      commaSeperatedValues = ''
      html << "<div id=\"#{'cloneId'+(t+1).to_s}\"  class=\"clone\" > <hr>"
      case div["type"]
      when :textBox
        option << "#{content_tag :option, "TextBox",:selected => "selected"}"
        option << "#{content_tag :option, "DropDown"}"

        html << "#{content_tag :label, "Element Name" }"
        html << "#{text_field_tag 'elementName'+(t+1).to_s, div["name"] }"
        html << "</br>"
        html << "#{content_tag :label, "Element Input Type" }"
        html << "#{select_tag "elementInputType"+(t+1).to_s,option.html_safe } <br><br />"
        html << "#{content_tag :label, "Element Repeatability" }"
        html << "#{select_tag "elementRepeatability"+(t+1).to_s,optionForRepeat.html_safe } <br><br />"
        html << "#{content_tag :label, "Element Options" }"
        html << "#{text_field_tag 'elementOptions'+(t+1).to_s, commaSeperatedValues }"
        html << "</br>"

      when:dropDown
        option << "#{content_tag :option, "TextBox"}"
        option << "#{content_tag :option, "DropDown",:selected => "selected"}"
        commaSeperatedValues = div["options"].join(",")
        
        html << "#{content_tag :label, "Element Name" }"
        html << "#{text_field_tag ('elementName'+(t+1).to_s), div["name"]}"
        html << "</br>"
        html << "#{content_tag :label, "Element Input Type" }"
        html << "#{select_tag ("elementInputType"+(t+1).to_s),option.html_safe } <br><br />"
        html << "#{content_tag :label, "Element Repeatability" }"
        html << "#{select_tag "elementRepeatability"+(t+1).to_s,optionForRepeat.html_safe } <br><br />"
        html << "#{content_tag :label, "Element Options" }"
        html << "#{text_field_tag 'elementOptions'+(t+1).to_s, commaSeperatedValues }"
        html << "</br>"        
      end
    html << "</br></br></div>"
    end      #end of each_index  
    return html.html_safe
  end #end of nonRepeat function
  

 def repeatElement array
   html = ''
   option = ''
   optionForRepeat = ''
   temp = 0
   temp = @repeat.length
   optionForRepeat << "#{content_tag :option, "One Element"}"
   optionForRepeat << "#{content_tag :option, "Multiple Elements",:selected => "selected"}"
   optionForRepeat << "#{content_tag :option, "comma Seperated Multiple"}"
   array.each_index do |t|
     html << "<div id=\"#{'cloneId'+(temp+t+1).to_s}\"  class=\"clone\" > <hr>"
     array[t].each_index do |f|
       commaSeperatedValues = ''
       case array[t][f]["type"]
       when :textBox
         option << "#{content_tag :option, "TextBox",:selected => "selected"}"
         option << "#{content_tag :option, "DropDown"}"

         html << "#{content_tag :label, "Element Name" }"
         html << "#{text_field_tag 'elementName'+(temp+t+1).to_s, array[t][f]["name"] }"
         html << "</br>"
         html << "#{content_tag :label, "Element Input Type" }"
         html << "#{select_tag "elementInputType"+(temp+t+1).to_s,option.html_safe } <br><br />"
         html << "#{content_tag :label, "Element Repeatability" }"
         html << "#{select_tag "elementRepeatability"+(temp+t+1).to_s,optionForRepeat.html_safe } <br><br />"
         html << "#{content_tag :label, "Element Options" }"
         html << "#{text_field_tag 'elementOptions'+(temp+t+1).to_s, commaSeperatedValues }"
         html << "</br>"
       when :dropDown
         option << "#{content_tag :option, "TextBox"}"
         option << "#{content_tag :option, "DropDown",:selected => "selected"}"
         commaSeperatedValues = array[t][f]["options"].join(",")

         html << "#{content_tag :label, "Element Name" }"
         html << "#{text_field_tag ('elementName'+(temp+t+1).to_s), array[t][f]["name"]}"
         html << "</br>"
         html << "#{content_tag :label, "Element Input Type" }"
         html << "#{select_tag ("elementInputType"+(temp+t+1).to_s),option.html_safe } <br><br />"
         html << "#{content_tag :label, "Element Repeatability" }"
         html << "#{select_tag "elementRepeatability"+(temp+t+1).to_s,optionForRepeat.html_safe } <br><br />"
         html << "#{content_tag :label, "Element Options" }"
         html << "#{text_field_tag 'elementOptions'+(temp+t+1).to_s, commaSeperatedValues }"
         html << "</br>"
         end
                 
     end
     html << "</br></br></div>"
   end
   return html.html_safe
 end #end of nonRepeat function
 
  	
  	
  	
  def script ary
    javascript = ''
     
    ary.each_index do |i|
      str = ary[i].map { |x| '\'' + x["name"].gsub('.', '\\\\\\\\.') + '\'' }.join ','
      javascript << '$("#b' + i.to_s + '").click(gen_add("' + 'c'+i.to_s+'","'+ i.to_s+'d' + '",[' + str + '], "nil"))'
      javascript << ';'
    end
    javascript.html_safe
  end
  	
end
