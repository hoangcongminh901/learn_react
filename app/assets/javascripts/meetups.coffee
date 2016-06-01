# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#Sử dụng React virtual DOM
DOM = React.DOM

# Tạo 1 class(component) mới - đây là phần chính chỗ nhập title/description..
FormInputWithLabel = React.createClass
  ###
  set những giá trị default cho các properties
  ở đây có thể thấy set thể loại của chỗ nhập là input, còn loại
  được chấp nhận là text
  ###
  getDefaultProps: ->
    elementType: "input"
    inputType: "text"
  # tên hiển thị, không set thì React cũng tự sinh, dành để debug làm chủ yếu
  displayName: "FormInputWithLabel"
  # đây là phần chính, cho hiển thị những gì
  render: ->
    # Đầu tiên là có 1 div
    DOM.div
      # có class name như dưới đây
      className: "form-group"
      # có chứa 1 thằng label tag
      DOM.label
        # giá trị for, không thể sử dụng for do vướng reserved word
        htmlFor: @props.id
        className: "col-lg-2 control-label"
        # lấy giá trị labelText truyền vào để hiển thị
        @props.labelText
      DOM.div
        # dựa vào giá trị warning truyền vào để thay đổi className value
        className: "col-lg-10 " + {true: "has-warning", false: ""}[!!@props.warning]
        # chạy hàm warning
        @warning()
        # sử dụng elementType truyền vào để set loại của ô nhập text
        DOM[@props.elementType]
          className: "form-control"
          placeholder: @props.placeholder
          id: @props.id
          type: "text"
          value: @props.value
          onChange: @props.onChange
          type: @tagType()
  tagType: ->
    {
      "input": @props.inputType,
      "textarea": null,
    }[@props.elementType]

  warning: ->
    return null unless @props.warning
    DOM.label
      className: "control-label"
      htmlFor: @props.id
      @props.warning

# tạo 1 element, như kiểu tạo 1 object từ class để có thể sử dụng
formInputWithLabel = React.createFactory(FormInputWithLabel)

# tạo 1 class mới, dành riêng chỗ seoText, có thể reset..
FormInputWithLabelAndReset = React.createClass
  displayName: "FormInputWithLabelAndReset"
  render: ->
    DOM.div
      className: "form-group"
      DOM.label
        htmlFor: @props.id
        className: "col-lg-2 control-label"
        @props.labelText
      DOM.div
        className: "col-lg-8"
        DOM.div
          className: "input-group"
          DOM.input
            className: "form-control"
            placeholder: @props.placeholder
            id: @props.id
            value: @props.value
            # đây là hàm React hỗ trợ sẵn
            onChange: (event) =>
              @props.onChange(event.target.value)
          DOM.span
            className: "input-group-btn"
            DOM.button
              onClick: () =>
                @props.onChange(null)
              className: "btn btn-default"
              type: "button"
              DOM.i
                className: "fa fa-magic"
            DOM.button
              onClick: () =>
                @props.onChange("")
              className: "btn btn-default"
              type: "button"
              DOM.i
                className: "fa fa-times-circle"

formInputWithLabelAndReset = React.createFactory(FormInputWithLabelAndReset)

monthName = (monthNumberStartingFromZero) ->
  [
    "January", "February", "March", "April", "May", "June", "July",
    "August", "September", "October", "November", "December"
  ][monthNumberStartingFromZero]

dayName = (date) ->
  dayNameStartingWithSundayZero = date.getDay()
  [
    "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
  ][dayNameStartingWithSundayZero]

DateWithLabel = React.createClass
  getDefaultProps: ->
    date: new Date()
  onYearChanged: (e) ->
    newDate = new Date(
      e.target.value,
      @props.date.getMonth(),
      @props.date.getDate()
    )
    @props.onChange(newDate)
  onMonthChanged: (e) ->
    newDate = new Date(
      @props.date.getFullYear(),
      e.target.value,
      @props.date.getDate()
    )
    @props.onChange(newDate)
  onDateChanged: (e) ->
    newDate = new Date(
      @props.date.getFullYear(),
      @props.date.getMonth(),
      e.target.value
    )
    @props.onChange(newDate)
  render: ->
    DOM.div
      className: "form-group"
      DOM.label
        className: "col-lg-2 control-label"
        "Date"
      DOM.div
        className: "col-lg-2"
        DOM.select
          className: "form-control"
          onChange: @onYearChanged
          value: @props.date.getFullYear()
          for year in [2015..2020]
            DOM.option(
              value: year,
              key: year,
              year
            )
      DOM.div
        className: "col-lg-3"
        DOM.select
          className: "form-control"
          onChange: @onMonthChanged
          value: @props.date.getMonth()
          for month in [0..11]
            DOM.option(
              value: month,
              key: month,
              "#{month+1}-#{monthName(month)}"
            )
      DOM.div
        className: "col-lg-2"
        DOM.select
          className: "form-control"
          onChange: @onDateChanged
          value: @props.date.getDate()
          for day in [1..31]
            date = new Date(
              @props.date.getFullYear(),
              @props.date.getMonth(),
              day
            )
            DOM.option(
              value: day,
              key: day,
              "#{day}-#{dayName(date)}"
            )

dateWithLabel = React.createFactory(DateWithLabel)

window.CreateNewMeetupForm = React.createClass
  displayName: "CreateNewMeetupForm"

  getInitialState: ->
    {
      meetup: {
        title: "",
        description: "",
        date: new Date(),
        seoText: null,
        guests: [""],
      }
      warnings: {
        title: null
      }
    }

  titleChanged: (e) ->
    @state.meetup.title = e.target.value
    @validateTitle()
    @forceUpdate()

  validateTitle: () ->
    @state.warnings.title = if /\S/.test(@state.meetup.title) then null else "Can not be blank"

  descriptionChanged: (e) ->
    @state.meetup.description = e.target.value
    @forceUpdate()

  dateChanged: (newDate) ->
    @state.meetup.date = newDate
    @forceUpdate()

  seoChanged: (seoText) ->
    @state.meetup.seoText = seoText
    @forceUpdate()

  guestEmailChanged: (number, e) ->
    guests = @state.meetup.guests
    guests[number] = e.target.value

    lastEmail = guests[guests.length - 1]
    penultimateEmail = guests[guests.length - 2]

    if (lastEmail != "")
      guests.push("")
    if (guests.length >= 2 && lastEmail == "" && penultimateEmail == "")
      guests.pop()

    @forceUpdate()

  computeDefaultSeoText: () ->
    words = @state.meetup.title.toLowerCase().split(/\s+/)
    words.push(monthName(@state.meetup.date.getMonth()))
    words.push(@state.meetup.date.getFullYear().toString())
    words.filter( (string) -> string.trim().length > 0).join("-").toLowerCase()

  formSubmitted: (e) ->
    e.preventDefault()
    meetup = @state.meetup

    @validateTitle()
    @forceUpdate()
    for own key of meetup
      return if @state.warnings[key]

    $.ajax
      url: "/meetups.json"
      type: "POST"
      dataType: "JSON"
      contentType: "application/json"
      processData: false
      data: JSON.stringify({meetup: {
        title: meetup.title
        description: meetup.description
        date: "#{meetup.date.getFullYear()}-#{meetup.date.getMonth()+1}-#{meetup.date.getDate()}"
        seo: @state.meetup.seoText || @computeDefaultSeoText()
        }})

  render: ->
    DOM.form
      onSubmit: @formSubmitted
      className: "form-horizontal"
      DOM.fieldset null,
        DOM.legend null, "New Meetup"

        formInputWithLabel
          id: "title"
          value: @state.meetup.title
          onChange: @titleChanged
          placeholder: "Meetup title"
          labelText: "Title"
          inputType: "search"

        formInputWithLabel
          id: "description"
          value: @state.meetup.description
          onChange: @descriptionChanged
          placeholder: "Meetup description"
          labelText: "Description"
          elementType: "textarea"
          warning: @state.warnings.title

        dateWithLabel
          onChange: @dateChanged
          date: @state.meetup.date

        formInputWithLabelAndReset
          id: "seo"
          value: if @state.meetup.seoText? then @state.meetup.seoText else @computeDefaultSeoText()
          onChange: @seoChanged
          placeholder: "SEO text"
          labelText: "seo"

      DOM.fieldset null,
        DOM.legend null, "Guests"
        for guest, n in @state.meetup.guests
          ((i) =>
            formInputWithLabel
              id: "email"
              key: "guest-#{i}"
              value: guest
              onChange: (e) =>
                @guestEmailChanged(i, e)
              placeholder: "Email address of an invitee"
              labelText: "Email"
          )(n)

        DOM.div
          className: "form-group"
          DOM.div
            className: "col-lg-10 col-lg-offset-2"
            DOM.button
              type: "submit"
              className: "btn btn-primary"
              "Save"