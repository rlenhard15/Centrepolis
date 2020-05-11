module JSONHelpers
  def parse_json(string)
    if JSON.parse(string).class == Hash
      JSON.parse(string).sort
    else
      JSON.parse(string).sort{|item| item["id"]}.reverse.map{|item| item.reject{|param| param == "created_at" || param =="updated_at"}}
    end
  end
end
