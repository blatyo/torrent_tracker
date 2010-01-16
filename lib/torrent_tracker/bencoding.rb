module TorrentTracker
  module BEncoding
    class ::String
      def bencode
        [length, ':', self].join
      end
    end

    class ::Symbol
      def bencode
        to_s.bencode
      end

      def <=>(o)
        to_s <=> o.to_s
      end
    end

    class ::Numeric
      def bencode
        to_int.bencode
      end
    end

    class ::Integer
      def bencode
        [:i, self, :e].join
      end
    end

    class ::Array
      def bencode
        collect do |element|
          element.bencode
        end.unshift(:l).push(:e).join
      end
    end

    class ::Hash
      def bencode
        keys.sort.collect do |key|
          key.bencode + self[key].bencode if self[key]
        end.unshift(:d).push(:e).join
      end
    end
  end
end