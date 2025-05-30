# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A complete TeX distribution"
HOMEPAGE="https://tug.org/texlive/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 sparc ~x86"
IUSE="cjk context extra games graphics humanities luatex metapost music pdfannotextractor png pstricks publishers science tex4ht texi2html truetype xetex xml X"

LANGS="af ar as bg bn br ca cs cy da de el en eo es et eu fa fi fr ga gl gu he
	hi hr hsb hu hy ia id is it ja ko kn la lo lt lv ml mn mr nb nl nn no or pa
	pl pt rm ro ru sa sco sk sl sq sr sv ta te th tk tr uk vi zh"

for X in ${LANGS}; do
	IUSE="${IUSE} l10n_${X}"
done

TEXLIVE_CAT="dev-texlive"

RDEPEND="
	>=app-text/texlive-core-${PV}
	app-text/psutils
	>=${TEXLIVE_CAT}/texlive-fontutils-${PV}
	media-gfx/sam2p
	texi2html? ( app-text/texi2html )
	sys-apps/texinfo
	app-text/t1utils
	>=app-text/lcdf-typetools-2.92[kpathsea]
	truetype? ( >=app-text/ttf2pk2-2.0_p20230311 )
	app-text/ps2eps
	png? ( app-text/dvipng )
	X? ( >=app-text/xdvik-22.87 )
	>=${TEXLIVE_CAT}/texlive-basic-${PV}
	>=${TEXLIVE_CAT}/texlive-fontsrecommended-${PV}
	>=${TEXLIVE_CAT}/texlive-latex-${PV}
	luatex? ( >=${TEXLIVE_CAT}/texlive-luatex-${PV} )
	>=${TEXLIVE_CAT}/texlive-latexrecommended-${PV}
	metapost? ( >=${TEXLIVE_CAT}/texlive-metapost-${PV} )
	>=${TEXLIVE_CAT}/texlive-plaingeneric-${PV}
	pdfannotextractor? ( dev-tex/pdfannotextractor )
	extra? (
		>=${TEXLIVE_CAT}/texlive-bibtexextra-${PV}
		>=${TEXLIVE_CAT}/texlive-binextra-${PV}
		>=${TEXLIVE_CAT}/texlive-fontsextra-${PV}
		>=${TEXLIVE_CAT}/texlive-formatsextra-${PV}
		>=${TEXLIVE_CAT}/texlive-latexextra-${PV}
	)
	xetex? ( >=${TEXLIVE_CAT}/texlive-xetex-${PV} )
	graphics? ( >=${TEXLIVE_CAT}/texlive-pictures-${PV} )
	science? ( >=${TEXLIVE_CAT}/texlive-mathscience-${PV} )
	publishers? ( >=${TEXLIVE_CAT}/texlive-publishers-${PV} )
	music? ( >=${TEXLIVE_CAT}/texlive-music-${PV} )
	pstricks? ( >=${TEXLIVE_CAT}/texlive-pstricks-${PV} )
	context? ( >=${TEXLIVE_CAT}/texlive-context-${PV} )
	games? ( >=${TEXLIVE_CAT}/texlive-games-${PV} )
	humanities? ( >=${TEXLIVE_CAT}/texlive-humanities-${PV} )
	tex4ht? ( >=dev-tex/tex4ht-20230311_p69739 )
	xml? ( >=${TEXLIVE_CAT}/texlive-formatsextra-${PV} )
	l10n_af?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_ar?    ( >=${TEXLIVE_CAT}/texlive-langarabic-${PV} )
	l10n_fa?    ( >=${TEXLIVE_CAT}/texlive-langarabic-${PV} )
	l10n_hy?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	cjk? ( >=${TEXLIVE_CAT}/texlive-langcjk-${PV} )
	l10n_hr?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_bg?    ( >=${TEXLIVE_CAT}/texlive-langcyrillic-${PV} )
	l10n_br?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_ru?    ( >=${TEXLIVE_CAT}/texlive-langcyrillic-${PV} )
	l10n_uk?    ( >=${TEXLIVE_CAT}/texlive-langcyrillic-${PV} )
	l10n_cs?    ( >=${TEXLIVE_CAT}/texlive-langczechslovak-${PV} )
	l10n_sk?    ( >=${TEXLIVE_CAT}/texlive-langczechslovak-${PV} )
	l10n_da?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_nl?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_en?    ( >=${TEXLIVE_CAT}/texlive-langenglish-${PV} )
	l10n_fi?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_eu?    ( >=${TEXLIVE_CAT}/texlive-langfrench-${PV} )
	l10n_fr?    ( >=${TEXLIVE_CAT}/texlive-langfrench-${PV} )
	l10n_de?    ( >=${TEXLIVE_CAT}/texlive-langgerman-${PV} )
	l10n_el?    ( >=${TEXLIVE_CAT}/texlive-langgreek-${PV} )
	l10n_he?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_hu?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_as?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_bn?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_gu?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_hi?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_kn?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_ml?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_mr?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_or?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_pa?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_sa?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_ta?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_te?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_it?    ( >=${TEXLIVE_CAT}/texlive-langitalian-${PV} )
	l10n_ja?    ( >=${TEXLIVE_CAT}/texlive-langjapanese-${PV} )
	l10n_ko?    ( >=${TEXLIVE_CAT}/texlive-langkorean-${PV} )
	l10n_la?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_lt?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_lv?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_mn?    ( >=${TEXLIVE_CAT}/texlive-langcyrillic-${PV} )
	l10n_nb?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_nn?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_no?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_cy?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_eo?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_et?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_ga?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_rm?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_hsb?   ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_ia?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_id?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_is?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_lo?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_ro?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_sq?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_sr?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV}
				  >=${TEXLIVE_CAT}/texlive-langcyrillic-${PV} )
	l10n_sl?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_tr?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_pl?    ( >=${TEXLIVE_CAT}/texlive-langpolish-${PV} )
	l10n_pt?    ( >=${TEXLIVE_CAT}/texlive-langportuguese-${PV} )
	l10n_ca?    ( >=${TEXLIVE_CAT}/texlive-langspanish-${PV} )
	l10n_gl?    ( >=${TEXLIVE_CAT}/texlive-langspanish-${PV} )
	l10n_es?    ( >=${TEXLIVE_CAT}/texlive-langspanish-${PV} )
	l10n_sco?   ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_sv?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_tk?    ( >=${TEXLIVE_CAT}/texlive-langeuropean-${PV} )
	l10n_vi?    ( >=${TEXLIVE_CAT}/texlive-langother-${PV} )
	l10n_zh?    ( >=${TEXLIVE_CAT}/texlive-langchinese-${PV} )
"
