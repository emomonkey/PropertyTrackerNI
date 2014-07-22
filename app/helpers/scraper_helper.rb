module ScraperHelper

  def ul_column2(most_sales_by_cnty)
    icnt = 1

    content_tag(:ul, :class => 'list2col') do
      most_sales_by_cnty.each do |item|
        concat(content_tag(:li, icnt.to_s + ":" + item.searchparam + " " + item.county))
        icnt += 1
      end
    end



  end
   # <ul class="list2col">
   # <% icnt = 1 %>
  #  <% @mostsalescnty.each do |pavol| %>
     # <li><%= icnt.to_s + ":" + pavol.searchparam + " " +  pavol.county %> <li>
    #  <% icnt += 1 %>
   # <% end %>
  #  </ul>


end
