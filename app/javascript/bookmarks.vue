<template lang="pug">
.page-body
  .container.is-md(v-if='!loaded')
    loadingListPlaceholder
  .container.is-md(v-else)
    .o-empty-message(v-if='bookmarks.length === 0')
      .o-empty-message__icon
        i.fa-regular.fa-sad-tear
      p.o-empty-message__text
        | ブックマークしているものはありません。
    div(v-else)
      nav.pagination(v-if='totalPages > 1')
        pager(v-bind='pagerProps')
      .card-list-tools
        .form-item.is-inline
          label.a-form-label(for='card-list-tools__action')
            | 編集
          label.a-on-off-checkbox.is-sm
            input#card-list-tools__action(
              type='checkbox',
              name='card-list-tools__action',
              v-model='checked'
            )
            span#spec-edit-mode
      .card-list.a-card
        .card-list__items
          bookmark(
            v-for='bookmark in bookmarks',
            :key='bookmark.id',
            :bookmark='bookmark',
            :checked='checked',
            @updateIndex='updateIndex'
          )
      nav.pagination(v-if='totalPages > 1')
        pager(v-bind='pagerProps')
</template>
<script>
import Bookmark from 'bookmark.vue'
import Pager from 'pager.vue'
import LoadingListPlaceholder from 'loading-list-placeholder'

export default {
  components: {
    bookmark: Bookmark,
    pager: Pager,
    loadingListPlaceholder: LoadingListPlaceholder
  },
  data() {
    return {
      bookmarks: [],
      totalPages: 0,
      currentPage: Number(this.getPageValueFromParameter()) || 1,
      loaded: false,
      checked: false
    }
  },
  computed: {
    url() {
      return `/api/bookmarks?page=${this.currentPage}`
    },
    pagerProps() {
      return {
        initialPageNumber: this.currentPage,
        pageCount: this.totalPages,
        pageRange: 5,
        clickHandle: this.paginateClickCallback
      }
    }
  },
  created() {
    window.onpopstate = function () {
      location.replace(location.href)
    }
    this.getBookmarks()
  },
  methods: {
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
    getBookmarks() {
      fetch(this.url, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.token()
        },
        credentials: 'same-origin',
        redirect: 'manual'
      })
        .then((response) => {
          return response.json()
        })
        .then((json) => {
          this.bookmarks = []
          json.bookmarks.forEach((bookmark) => {
            this.bookmarks.push(bookmark)
          })
          this.totalPages = parseInt(json.totalPages)
          this.loaded = true
        })
        .catch((error) => {
          console.warn(error)
        })
    },
    getPageValueFromParameter() {
      const url = location.href
      const results = url.match(/\?page=(\d+)/)
      return results ? results[1] : null
    },
    paginateClickCallback(pageNumber) {
      this.currentPage = pageNumber
      this.getBookmarks()
      history.pushState(
        null,
        null,
        location.pathname + (pageNumber === 1 ? '' : `?page=${pageNumber}`)
      )
      window.scrollTo(0, 0)
    },
    updateIndex() {
      this.getBookmarks()
    }
  }
}
</script>
