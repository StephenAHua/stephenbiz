import { useState } from 'react'
import { Container, FormControl, FormLabel, Input, Textarea, Button, Stack, Heading, useToast, Text } from '@chakra-ui/react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const quoteSchema = z.object({
  product_id: z.string().optional(),
  quantity: z.number().min(1),
  custom_requirements: z.string().min(10),
  contact_name: z.string().min(2),
  email: z.string().email(),
  company: z.string().optional(),
})

type QuoteFormData = z.infer<typeof quoteSchema>

export default function QuotesPage() {
  const toast = useToast()
  const [submitting, setSubmitting] = useState(false)
  const { register, handleSubmit, formState: { errors }, reset } = useForm<QuoteFormData>({
    resolver: zodResolver(quoteSchema),
    defaultValues: {
      quantity: 1,
    }
  })

  const onSubmit = async (formData: QuoteFormData) => {
    setSubmitting(true)
    try {
      // In a real app, you'd create a quote record in Supabase
      // For now, simulate API call
      console.log('Quote submitted:', formData);
      await new Promise(resolve => setTimeout(resolve, 1000))
      toast({
        title: 'Quote submitted',
        description: 'We will contact you within 24 hours.',
        status: 'success',
        duration: 5000,
        isClosable: true,
      })
      reset()
    } catch (error) {
      toast({
        title: 'Error',
        description: 'Failed to submit quote. Please try again.',
        status: 'error',
        duration: 5000,
        isClosable: true,
      })
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <Container maxW="container.md" py={10}>
      <Stack spacing={8}>
        <Heading>Request a Quote</Heading>
        <Text fontSize="lg">
          Submit your custom product requirements and we'll provide a competitive quote within 24 hours.
        </Text>
        <form onSubmit={handleSubmit(onSubmit)}>
          <Stack spacing={6}>
            <FormControl isInvalid={!!errors.contact_name}>
              <FormLabel>Contact Name *</FormLabel>
              <Input {...register('contact_name')} placeholder="Your name" />
              {errors.contact_name && (
                <Text color="red.500" fontSize="sm">{errors.contact_name.message}</Text>
              )}
            </FormControl>
            <FormControl isInvalid={!!errors.email}>
              <FormLabel>Email *</FormLabel>
              <Input type="email" {...register('email')} placeholder="you@company.com" />
              {errors.email && (
                <Text color="red.500" fontSize="sm">{errors.email.message}</Text>
              )}
            </FormControl>
            <FormControl>
              <FormLabel>Company</FormLabel>
              <Input {...register('company')} placeholder="Company name (optional)" />
            </FormControl>
            <FormControl isInvalid={!!errors.quantity}>
              <FormLabel>Quantity *</FormLabel>
              <Input type="number" {...register('quantity', { valueAsNumber: true })} min={1} />
              {errors.quantity && (
                <Text color="red.500" fontSize="sm">{errors.quantity.message}</Text>
              )}
            </FormControl>
            <FormControl isInvalid={!!errors.custom_requirements}>
              <FormLabel>Custom Requirements *</FormLabel>
              <Textarea {...register('custom_requirements')} placeholder="Describe your product needs, specifications, budget, timeline..." rows={6} />
              {errors.custom_requirements && (
                <Text color="red.500" fontSize="sm">{errors.custom_requirements.message}</Text>
              )}
            </FormControl>
            <Button type="submit" colorScheme="blue" size="lg" isLoading={submitting}>
              Submit Quote Request
            </Button>
          </Stack>
        </form>
      </Stack>
    </Container>
  )
}