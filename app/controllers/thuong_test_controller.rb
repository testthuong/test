# class Tmp
#   name
#   age
# end
class ThuongTestController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :khoe
  $global_obj=[]

  def ThuongTest
    objTmp= Hash.new
    objTmp[:name]= "thuong"
    objTmp[:age] = 12
    $global_obj.push(objTmp)
    objTmp= Hash.new
    objTmp[:name]= "Hau"
    objTmp[:age] = 11
    $global_obj.push(objTmp)
    objTmp= Hash.new
    objTmp[:name]= "Giang"
    objTmp[:age] = 12
    $global_obj.push(objTmp)
    @obj =$global_obj

    render "ThuongTest"
  end




  def ThuongTest22
    if(params[:btnSearch]==nil)

      objTmp= Hash.new
      objTmp[:name]= "thuong2"
      objTmp[:age] = 122222222
      $global_obj.push(objTmp)
      objTmp= Hash.new
      objTmp[:name]= "Hau2"
      objTmp[:age] = 112222222
      $global_obj.push(objTmp)
      objTmp= Hash.new
      objTmp[:name]= "Giang2"
      objTmp[:age] = 12222222
      $global_obj.push(objTmp)



      @txtName = params[:txtName]
      @txtAge = params[:txtAge]
      objTmp= Hash.new
      objTmp[:name]= @txtName
      objTmp[:age] = @txtAge
      $global_obj.push(objTmp)
      @obj= $global_obj
    else
      $global_obj.each { |obj|
        if obj[:name] == params[:txtSearch]
          @result=obj[:name]
          _obj=[]
          _obj.push(obj)
          @obj=_obj
          render "ThuongTest"
          return
        end
      }
      @obj= $global_obj
    end




    render "ThuongTest"
  end


  def khoe
    # $global_obj=[]
  end



end
