class OptionController < ApplicationController

  def visi
    if !params.include?(:mesEleves)
      mesEleves = "0"
    else
      mesEleves = params[:mesEleves]
    end
    acces = String.new
    nomdesk = params[:draw].to_s.gsub(/\s+/, '_')
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
    Desk.update(cdid, :publish => acces)
    redirect_to :back
  end

  # DEPLACEMENT DES DESKS

  def deplac
    nomdesk = params["/deplac"][:draw].to_s.gsub(/\s+/, '_')
    @desks = Desk.where(:compte_id => ccid(params["/deplac"][:desk])).all
    @desks = @desks.sort_by { |x| x[:rang] }
    currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params["/deplac"][:desk])).take
    cdid = currentdesk.id

    if params["/deplac"][:direction] == "left"
      @desks.each_with_index do |d, i|
        if d == currentdesk
          deskg = @desks[i-1]
          deskd = @desks[i]
          Desk.update(deskg.id, :rang => i)
          Desk.update(deskd.id, :rang => i-1)
        end
      end
    elsif params["/deplac"][:direction] == "right"
      @desks.each_with_index do |d, i|
        if d == currentdesk
          deskg = @desks[i]
          deskd = @desks[i+1]
          Desk.update(deskg.id, :rang => i+1)
          Desk.update(deskd.id, :rang => i)
        end
      end
    end
    redirect_to desk_path(current_user)
  end

  # DEPLACEMENT DES DRAWS

  def deplacd
    nomdesk = params["/deplacd"][:desk].to_s.gsub(/\s+/, '_')
    currentdesk = Desk.where(:route => nomdesk, :compte_id => ccid(params["/deplacd"][:cpte])).take
    nomdraw = params["/deplacd"][:draw].to_s.gsub(/\s+/, '_')
    currentdraw = Draw.where(:route => nomdraw, :desk_id => currentdesk.id).take
    cdid = currentdesk.id
    @draws = Draw.where(desk_id: cdid).all
    @draws = @draws.sort_by { |x| x[:rang] }

    if params["/deplacd"][:direction] == "left"
      @draws.each_with_index do |d, i|
        if d == currentdraw
          drawg = @draws[i-1]
          drawd = @draws[i]
          Draw.update(drawg.id, :rang => i)
          Draw.update(drawd.id, :rang => i-1)
        end
      end
    elsif params["/deplacd"][:direction] == "right"
      @draws.each_with_index do |d, i|
        if d == currentdraw
          drawg = @draws[i]
          drawd = @draws[i+1]
          Draw.update(drawg.id, :rang => i+1)
          Draw.update(drawd.id, :rang => i)
        end
      end
    end
    redirect_to :back
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
