class OptionController < ApplicationController

  def visi
    if !params.include?(:mesEleves)
      mesEleves = "0"
    else
      mesEleves = params[:mesEleves]
    end
    acces = String.new
    nomdesk = params[:draw]
    currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params[:desk])).take
    cdid = currentdesk.id
    @eleves = liste_eleves
    i = 0
    @eleves.each do |el|
      if el.id == mesEleves[i].to_i
        acces = acces + "1"
        i = i + 1
      else
        acces = acces + "O"
      end
    end
    puts ('ACCES')
    puts acces.inspect
    Desk.update(cdid, :publish => acces)
    redirect_to :back
  end

  def deplac
    puts('OKOKOKOK')
    nomdesk = params["/deplac"][:draw]
    @desks = Desk.where(:compte_id => ccid(params["/deplac"][:desk])).all
    currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params["/deplac"][:desk])).take
    cdid = currentdesk.id

    if params["/deplac"][:direction] == "left"
      puts('à gauche')
      @desks.each_with_index do |d, i|
        if d == currentdesk
          deskg = @desks[i-1]
          deskd = @desks[i]
          # Desk.update(deskg.id, :name => deskd.name, :route => deskd.route, :publish => deskd.publish)
          # Desk.update(cdid, :name => deskg.name, :route => deskg.route, :publish => deskg.publish)
        end
      end
    elsif params["/deplac"][:direction] == "right"
      puts('à droite')
    end
    redirect_to desk_path(current_user)
  end

  #==============================================================
  #                     PRIVATE
  #==============================================================
    private

    def ccid(cpte)
      nomcompte = cpte.to_s.gsub(/\s+/, '_')
      currentcompte = Compte.where(:nom => nomcompte).take
      ccid = currentcompte.id
    end

end
