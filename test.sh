#set-up for single machine or cluster based execution
. ./cmd.sh
#set the paths to binaries and other executables
[ -f path.sh ] && . ./path.sh


train_dict=dict
train_lang=lang_bigram
train_folder=train
nj=1


echo
echo "===== MONO DECODING ====="
echo
utils/mkgraph.sh --mono data/$train_lang exp/mono exp/mono/graph || exit 1
steps/decode.sh --config conf/decode.config --nj $nj --cmd "$decode_cmd" exp/mono/graph data/test exp/mono/decode



echo "===== TRI1 (first triphone pass) DECODING ====="
echo
utils/mkgraph.sh data/$train_lang exp/tri1 exp/tri1/graph || exit 1
steps/decode.sh --config conf/decode.config --nj $nj --cmd "$decode_cmd" exp/tri1/graph data/test exp/tri1/decode

echo "===== TRI_LDA (second triphone pass) DECODING ====="
echo
utils/mkgraph.sh data/$train_lang exp/tri_lda exp/tri_lda/graph 
steps/decode.sh --config conf/decode.config --nj $nj --cmd "$decode_cmd" exp/tri_lda/graph data/test exp/tri_lda/decode


echo "===== TRI_LDA (second triphone pass) DECODING ====="
echo
utils/mkgraph.sh data/$train_lang exp/tri_sat exp/tri_sat/graph 
steps/decode.sh --config conf/decode.config --nj $nj --cmd "$decode_cmd" exp/tri_sat/graph data/test exp/tri_sat/decode


echo ============================================================================
echo "                   End of Script             	        "
echo ============================================================================