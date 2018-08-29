class BookDecorator < Draper::Decorator
  delegate_all

  def authors_short
    collect_authors do |authors|
      authors.map { |author| "#{author.first_name[0]}. #{author.last_name}" }
    end
  end

  def authors_full
    collect_authors do |authors|
      authors.map { |author| "#{author.first_name} #{author.last_name}" }
    end
  end

  def materials_string
    model.materials.map(&:name).sort.join(', ').capitalize
  end

  def dimensions
    "H: #{model.height}\" x W: #{model.width}\" x D: #{model.thickness}\""
  end

  private

  def collect_authors
    yield(model.authors.sort_by(&:last_name)).join(', ')
  end
end
